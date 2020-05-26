//
//  LiveActivityDetails.swift
//  colour-run-map
//
//  Created by Luke on 22/05/2020.
//  Copyright © 2020 Kris Skierniewski. All rights reserved.
//

import SwiftUI
import CoreLocation

struct ActivityDetails: View {
    
    private let distance: CLLocationDistance
    private let duration: TimeInterval
    private var pace: TimeInterval
    
    init(locations: [CLLocation]) {
        let distance = DistanceHelper.sumOfDistances(betweenLocations: locations)
        var duration: TimeInterval = 0
        
        if let first = locations.first, let last = locations.last {
            duration = abs(first.timestamp.timeIntervalSince(last.timestamp))
        }
        
        let pace = PaceHelper.calculatePace(distance: distance, duration: duration)
        
        self.distance = distance
        self.duration = duration
        self.pace = pace
    }
    
    init(activity: Activity) {
        self.init(locations: activity.locations)
    }
    
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
        return ActivityDetails(locations: MockHelper.mockLocations)
            .previewLayout(.sizeThatFits)
    }
}
