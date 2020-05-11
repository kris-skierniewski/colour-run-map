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
    
    @State private var headerText: String = LocationManager().locationAutherisationStatus?.asString ?? "?"
    
    private var locationManager: LocationManager = LocationManager()
    
    private var mapView = MapView()
    
    private func buttonTappedHandler() {
        if let location = locationManager.recentLocation {
            mapView.showUserLocation()
            mapView.zoom(to: location)
        } else if locationManager.canGetLocation {
            locationManager.getLocation { location in
                guard let location = location else { return }
                self.mapView.showUserLocation()
                self.mapView.zoom(to: location)
            }
        } else {
            locationManager.requestWhenInUseAuthorization { status in
                self.headerText = status.asString
                
                self.locationManager.getLocation { location in
                    guard let location = location else { return }
                    self.mapView.showUserLocation()
                    self.mapView.zoom(to: location)
                }
            }
        }
        
    }
    
    var body: some View {
        ZStack {
            mapView
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                Text("Location Auth Status: \(headerText)")
                    .animation(.spring())
                Spacer()
                HStack{
                    Spacer()
                    TextButtonView(text: "Start",
                                   backgroundColor: .green,
                                   tappedHandler: buttonTappedHandler)
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
    }
}

