//
//  LiveActivityDetails.swift
//  colour-run-map
//
//  Created by Luke on 22/05/2020.
//  Copyright © 2020 Kris Skierniewski. All rights reserved.
//

import SwiftUI
import CoreLocation

struct LiveActivityDetails: View {
    
    var locations: [CLLocation]
    
    private var distance: CLLocationDistance {
        return DistanceHelper.sumOfDistances(betweenLocations: locations)
    }
    
    private var duration: TimeInterval {
        guard let first = locations.first, let last = locations.last else { return 0 }
        return abs(first.timestamp.timeIntervalSince(last.timestamp))
    }
    
    private var pace: TimeInterval {
        return PaceHelper.calculatePace(distance: distance, duration: duration) }
    
    var body: some View {
        HStack() {
            StackedTextView(topText: "\(distance.mwKilometersRoundedDown2dp)", bottomText: "distance")
            Spacer()
            StackedTextView(topText: "\(duration.asString)", bottomText: "time")
            Spacer()
            StackedTextView(topText: "\(pace.asString)", bottomText: "min/km")
        }
        .padding(.horizontal)
    }
}

struct LiveActivityDetails_Previews: PreviewProvider {
    static var previews: some View {
        let loc1 = CLLocation(coordinate: CLLocationCoordinate2D(latitude: 36.063457, longitude: -95.880516),
                              altitude: CLLocationDistance(exactly: 0.0)!,
                              horizontalAccuracy: CLLocationAccuracy(exactly: 1)!,
                              verticalAccuracy: CLLocationAccuracy(exactly: 1)!,
                              timestamp: Date())
        
        let loc2 = CLLocation(coordinate: CLLocationCoordinate2D(latitude: 36.063457, longitude: -95.980516),
                              altitude: CLLocationDistance(exactly: 0.0)!,
                              horizontalAccuracy: CLLocationAccuracy(exactly: 1)!,
                              verticalAccuracy: CLLocationAccuracy(exactly: 1)!,
                              timestamp: Date().addingTimeInterval(.minuteInSeconds))
        
        let mockLocations = [loc1, loc2]
        
        return LiveActivityDetails(locations: mockLocations)
            .previewLayout(.sizeThatFits)
    }
}
