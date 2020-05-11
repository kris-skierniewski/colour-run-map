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
//
//    private var mapView = MapView()
    
    private func startButtonTappedHandler() {
        userData.isRecordingActivity.toggle()
        locationManager.startRecordingLocation()
    
    }
    private func stopButtonTappedHandler() {
        userData.isRecordingActivity.toggle()
        locationManager.stopRecordingLocation()
    }
    
    var body: some View {
        ZStack {
            MapView(recordedLocations: locationManager.recordedLocations)
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                Text("Recorded locations: \(locationManager.recordedLocations.description)")
                    .animation(.spring())
                Spacer()
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

