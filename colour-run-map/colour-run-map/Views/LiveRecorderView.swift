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
    @State private var currentKilometerProgress: Double = 0
    
    @ObservedObject private var locationManager: LocationManager = LocationManager.shared
    
    @Environment(\.managedObjectContext) private var managedObjectContext
    
    @EnvironmentObject var userData: UserData
    
    var body: some View {
        ZStack {
            MapView(selectedAnnotation: .constant(nil),
                    polylineType: .speed,
                    mapState: isRecording ? .showRecordingActivity : .showUserLocation,
                    recordedLocations: locationManager.recordedLocations)
                .edgesIgnoringSafeArea(.all)
            
            if isRecording {
                VStack {
                    RecordingHeadBar(recordedLocations: locationManager.recordedLocations)
                    Spacer()
                }
            }
            
            StartStopButtonWithProgressView(isRecording: $isRecording,
                                            showingAlert: $showingAlert,
                                            currentKilometerProgress: $currentKilometerProgress,
                                            startStopButtonTappedHandler: startStopButtonTappedHandler)
        }
    }
    
    // MARK: - Timer
    @State var now: Date = Date()
    private var timer: Timer {
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) {_ in
            self.now = Date()
            self.currentKilometerProgress = self.currentKiloMeterProgress()
        }
    }
    
    // MARK: - Actions
    private func startStopButtonTappedHandler() {
        if isRecording {
            locationManager.stopRecordingLocation()
            timer.invalidate()
            saveActivity()
            self.currentKilometerProgress = 0
        } else {
            locationManager.startRecordingLocation()
            timer.fire()
        }
        isRecording.toggle()
    }
    
    // MARK: - Helpers
    private func currentKiloMeterProgress() -> Double {
        let totalDistance = DistanceHelper.sumOfDistances(betweenLocations: locationManager.recordedLocations) // meters
        let wholeKm = Int(floor(totalDistance / .kilometerInMeters))
        let distanceInKm = totalDistance / .kilometerInMeters
        let delta = distanceInKm - Double(wholeKm)
        return delta
    }
    
    private func saveActivity() {
        if locationManager.recordedLocations.count == 0 {
            showingAlert = true
        } else {
            let activity = Activity(context: managedObjectContext)
            activity.locations = locationManager.recordedLocations
            activity.id = UUID().uuidString
            activity.createdAt = Date()            
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


struct RecordingHeadBar: View {
    
    var recordedLocations: [CLLocation]
    
    var body: some View {
        ZStack {
            ActivityDetails(locations: recordedLocations)
                .padding([.bottom, .top], 10)
        }
        .background(BlurView().edgesIgnoringSafeArea(.top))
        .cornerRadius(20, corners: .allCorners)
        .padding([.leading, .trailing], 10)
    }
    
}

fileprivate struct StartStopButtonWithProgressView: View {
    
    @Binding var isRecording: Bool
    @Binding var showingAlert: Bool
    @Binding var currentKilometerProgress: Double
    
    var startStopButtonTappedHandler: (() -> Void)?
    
    var body: some View {
        VStack {
            Spacer()
            
            HStack{
                Spacer()
                ZStack (alignment: .center){
                    if isRecording {
                        CircularProgressBar(color: .yellow, diameter: 120, lineWidth: 5, progress: $currentKilometerProgress)
                    }
                    
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
                    
                }.frame(width: 150, height: 150)
                
                
                Spacer()
            }
            Spacer()
                .frame(height: 50)
        }
    }
}
