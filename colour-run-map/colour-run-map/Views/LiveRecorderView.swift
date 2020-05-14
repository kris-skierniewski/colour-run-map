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
    
    @State private var isRecording: Bool = false
    @State private var currentActivity: Activity? = nil
    @State private var mapState: MapState = .showUserLocation
    
    var locationManager: LocationManager = LocationManager.shared
    
    @Environment(\.managedObjectContext) var managedObjectContext
    
    @EnvironmentObject var userData: UserData
    
    @State private var timer: Timer? = nil
    
    private func startTimer() {
        self.timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) {_ in
            self.mapState = .showPartialRoute(self.locationManager.recordedLocations.map({ $0.coordinate }))
        }
        self.timer?.fire()
    }
    private func stopTimer() {
        self.timer?.invalidate()
        self.timer = nil
    }
    
    private func startStopButtonTappedHandler() {
        if isRecording {
            mapState = .showUserLocation
            locationManager.stopRecordingLocation()
            stopTimer()
            saveActivity()
        } else {
            locationManager.startRecordingLocation()
            mapState = .showPartialRoute(locationManager.recordedLocations.map({ $0.coordinate }))
            startTimer()
        }
        isRecording.toggle()
    }
    
    private func saveActivity() {
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
    
    var body: some View {
        ZStack {
            MapView(mapState: $mapState)
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                Spacer()
                    .frame(height: 10)
                HStack{
                    Spacer()
                    TextButtonView(text: isRecording ? "Stop" : "Start",
                                   backgroundColor: isRecording ? .red : .green,
                                   tappedHandler: startStopButtonTappedHandler)
                    Spacer()
                        .frame(width: 10)
                }
                Spacer()
            }
            
            VStack {
                Spacer().frame(height: 70)
                if isRecording {
                    Text("Distance: \(locationManager.distance.mwKilometersRoundedDown2dp)")
                        .font(.system(size: 30))
                    Text("Time: \(locationManager.startDate.mwTimeSinceNow)")
                        .font(.system(size: 30))
                    Text("Pace: \(PaceHelper.paceString(distance: locationManager.distance, startDate: locationManager.startDate))")
                        .font(.system(size: 30))
                }
                Spacer()
            }
            
            CardView(height: 150) {
                Text("Content")
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
