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
                Spacer().frame(height: 70)
                if isRecording {
                    Text("Distance: \(locationManager.distance.mwKilometersRoundedDown2dp)")
                        .font(.system(size: 30))
                    Text("Time: \(locationManager.startDate.mwTimeSince(now))")
                        .font(.system(size: 30))
                    Text("Pace: \(PaceHelper.paceString(distance: locationManager.distance, startDate: locationManager.startDate))")
                        .font(.system(size: 30))
                }
                Spacer()
            }
            
            VStack {
                Spacer()
                    .frame(height: 10)
                HStack{
                    Spacer()
                    TextButtonView(text: isRecording ? "Stop" : "Start",
                                   backgroundColor: isRecording ? .red : .green,
                        tappedHandler: startStopButtonTappedHandler)
                        .alert(isPresented: $showingAlert) { Alert(title: Text("Failed to save"),
                                                                   message: Text("We could not save your activity"),
                                                                   dismissButton: .default(Text("OK"))) }
                    Spacer()
                        .frame(width: 10)
                }
                Spacer()
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
