//
//  ContentView.swift
//  colour-run-map
//
//  Created by Kris Skierniewski on 07/05/2020.
//  Copyright © 2020 Kris Skierniewski. All rights reserved.
//

import SwiftUI
import MapKit

struct ContentView: View {
    
    @State var route: MKPolyline? = nil
    
//    @State private var headerText: String = LocationManager().locationAutherisationStatus?.asString ?? "?"
//
//    @State private var recordedLocations: [CLLocation] = LocationManager().recordedLocations
    
    @ObservedObject var locationManager: LocationManager = LocationManager.shared
    
    @EnvironmentObject var userData: UserData
    
    @State var now: Date = Date()
    var timer: Timer {
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) {_ in
            self.now = Date()
        }
        
    }
    
    var distanceFormatter: MKDistanceFormatter {
        let formatter = MKDistanceFormatter()
        formatter.units = .metric
        formatter.unitStyle = .abbreviated
        return formatter
    }
//
//    private var mapView = MapView()
    
    private func startButtonTappedHandler() {
        userData.isRecordingActivity.toggle()
        locationManager.startRecordingLocation()
        timer.fire()
    
    }
    private func stopButtonTappedHandler() {
        userData.isRecordingActivity.toggle()
        locationManager.stopRecordingLocation()
        timer.invalidate()
    }
    
    func timeString(from date: Date, until now: Date) -> String {
        let calendar = Calendar(identifier: .gregorian)
        let components = calendar.dateComponents([.hour, .minute, .second], from: date, to: now)
        return String(format: "%02d:%02d:%02d", components.hour ?? 00, components.minute ?? 00, components.second ?? 00)
    }
    
    func paceString(distance: CLLocationDistance, start: Date) -> String {
        let seconds = abs(start.timeIntervalSinceNow)
        guard distance > 0.0 else {
            return "00:00:00/km"
        }
        let pace = seconds / (distance / 1000)
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.unitsStyle = .positional
        
        return String(format: "%@/km",formatter.string(from: pace) ?? "00:00:00")
    }
    
    var body: some View {
        ZStack {
            MapView(recordedLocations: locationManager.recordedLocations)
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                Text("Recorded locations: \(locationManager.recordedLocations.description)")
                    .animation(.spring())
                Spacer()
                if userData.isRecordingActivity {
                    Text("Distance: \(distanceFormatter.string(fromDistance: locationManager.distance))")
                        .font(.system(size: 30))
                    Text("Time: \(timeString(from: locationManager.startDate, until: now))")
                        .font(.system(size: 30))
                    Text("Pace: \(paceString(distance: locationManager.distance, start: locationManager.startDate))")
                        .font(.system(size: 30))
                }
                HStack{
                    Spacer()
                    if userData.isRecordingActivity {
                        TextButtonView(text: "Stop",
                        backgroundColor: .red,
                        tappedHandler: stopButtonTappedHandler)
                    } else {
                        TextButtonView(text: "Start",
                        backgroundColor: .green,
                        tappedHandler: startButtonTappedHandler)
                    }

                    Spacer()
                        .frame(width: 10)
                }
                Spacer()
                    .frame(height: 10)
            }
        }
        
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
        .environmentObject(UserData())
    }
}

