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
    
    //@State var route: MKPolyline? = nil
    
//    @State private var headerText: String = LocationManager().locationAutherisationStatus?.asString ?? "?"
    
    @ObservedObject var locationManager: LocationManager = LocationManager.shared
    
    @Environment(\.managedObjectContext) var managedObjectContext
    //@FetchRequest(fetchRequest: Activity.fetchRequest()) var activities: FetchedResults<Activity>
    
    @EnvironmentObject var userData: UserData
    
    @State var now: Date = Date()
    var timer: Timer {
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) {_ in
            self.now = Date()
        }
    }
    
    private var formatter = Formatter()
    
    private func startButtonTappedHandler() {
        locationManager.startRecordingLocation()
        userData.isRecordingActivity.toggle()
        timer.fire()
    
    }
    private func stopButtonTappedHandler() {
        userData.isRecordingActivity.toggle()
        locationManager.stopRecordingLocation()
        timer.invalidate()
        
        let activity = Activity(context: managedObjectContext)
        activity.locations = locationManager.recordedLocations
        activity.id = UUID().uuidString
        activity.createdAt = Date()
        activity.distance = locationManager.distance
        activity.time = abs(locationManager.startDate.timeIntervalSinceNow)
        
        do {
            try self.managedObjectContext.save()
            print("successfully saved")
        } catch {
            print(error)
        }
    }
    
    var body: some View {
        ZStack {
            MapView(recordedLocations: locationManager.recordedLocations)
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                Text("Recorded activities: \(0)")
                    .animation(.spring())
                Spacer()
                if userData.isRecordingActivity {
                    Text("Distance: \(formatter.distanceString(from: locationManager.distance))")
                        .font(.system(size: 30))
                    Text("Time: \(formatter.timeString(from: locationManager.startDate, until: now))")
                        .font(.system(size: 30))
                    Text("Pace: \(formatter.paceString(distance: locationManager.distance, start: locationManager.startDate))")
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

