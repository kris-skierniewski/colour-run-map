//
//  ContentView.swift
//  colour-run-map
//
//  Created by Kris Skierniewski on 07/05/2020.
//  Copyright © 2020 Kris Skierniewski. All rights reserved.
//

import SwiftUI
import MapKit

struct LiveRecorderView: View {
    
    @State private var showingAlert = false
    @State private var isRecording: Bool = false
    
    @ObservedObject private var locationManager: LocationManager = LocationManager.shared
    
    @Environment(\.managedObjectContext) private var managedObjectContext
    
    @EnvironmentObject var userData: UserData
    
    var body: some View {
        ZStack {
            MapView(selected: .constant(nil),
                    polylineType: .speed,
                    mapState: isRecording ? .showRecordingActivity : .showUserLocation,
                    recordedLocations: locationManager.recordedLocations)
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                ZStack {
                    if isRecording {
                        LiveActivityDetails(locations: locationManager.recordedLocations)
                            .padding(.bottom, 10)
                            .background(BlurView().edgesIgnoringSafeArea(.top))
                    }
                }
                .cornerRadius(20, corners: [.bottomLeft, .bottomRight])
                Spacer()
            }
            
            VStack {
                Spacer()
                
                HStack{
                    Spacer()
                    CirlceButton(diameter: 100,
                                 backgroundColor: isRecording ? .red : .green,
                                 tappedHandler: startStopButtonTappedHandler) {
                                    Text(isRecording ? "Stop" : "Start")
                                        .fontWeight(.bold)
                                        .font(.system(size: 30))
                                        .foregroundColor(Color.white)
                                        .multilineTextAlignment(.center)
                                        .lineLimit(1)
                                        .padding(.all, 9.0)
                    }
                    .shadow(radius: 30)
                    .alert(isPresented: $showingAlert) { Alert(title: Text("Failed to save"),
                                                               message: Text("We could not save your activity"),
                                                               dismissButton: .default(Text("OK"))) }
                    Spacer()
                }
                Spacer()
                    .frame(height: 50)
            }
        }
    }
    
    // MARK: - Timer
    @State var now: Date = Date()
    private var timer: Timer {
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) {_ in
            self.now = Date()
        }
    }
    
    // MARK: - Actions
    private func startStopButtonTappedHandler() {
        if isRecording {
            locationManager.stopRecordingLocation()
            timer.invalidate()
            saveActivity()
        } else {
            locationManager.startRecordingLocation()
            timer.fire()
        }
        isRecording.toggle()
    }
    
    // MARK: - Helpers
    private func saveActivity() {
        if locationManager.recordedLocations.count == 0 {
            showingAlert = true
        } else {
            let activity = Activity(context: managedObjectContext)
            activity.locations = locationManager.recordedLocations
            activity.id = UUID().uuidString
            activity.createdAt = Date()
            activity.distance = locationManager.distance
            activity.duration = abs(locationManager.startDate.timeIntervalSinceNow)
            
            do {
                try self.managedObjectContext.save()
                print("successfully saved")
            } catch {
                print(error)
                showingAlert = true
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        LiveRecorderView()
            .environmentObject(UserData())
    }
}
