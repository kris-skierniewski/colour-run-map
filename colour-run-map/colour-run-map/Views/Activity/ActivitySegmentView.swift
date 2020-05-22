//
//  ActivitySegmentView.swift
//  colour-run-map
//
//  Created by Kris Skierniewski on 19/05/2020.
//  Copyright © 2020 Kris Skierniewski. All rights reserved.
//

import SwiftUI
import CoreLocation

struct ActivitySegmentView: View {
    var annotation: ActivityAnnotation
    
    var body: some View {
        VStack{
            if annotation.segment != nil {
                VStack{
                    Text("\(annotation.title!) Split")
                        .font(.title).bold()
                        .padding()
                    Text("Pace: \(PaceHelper.calculatePace(distance: DistanceHelper.sumOfDistances(betweenLocations: annotation.segment!), start: annotation.segment!.first!.timestamp, end: annotation.segment!.last!.timestamp).asString) min/km")
                }
            }
        }
    }
}

struct ActivitySegmentView_Previews: PreviewProvider {
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
        
        let loc3 = CLLocation(coordinate: CLLocationCoordinate2D(latitude: 36.063457, longitude: -96.180516),
                              altitude: CLLocationDistance(exactly: 0.0)!,
                              horizontalAccuracy: CLLocationAccuracy(exactly: 1)!,
                              verticalAccuracy: CLLocationAccuracy(exactly: 1)!,
                              timestamp: Date().addingTimeInterval(.minuteInSeconds * 2))
        
        let mockLocations = [loc1, loc2, loc3]
        
        let mockAnnotation = ActivityAnnotation()
        mockAnnotation.segment = mockLocations
        mockAnnotation.title = "Sample"
        
        return ActivitySegmentView(annotation: mockAnnotation)
            .previewLayout(.sizeThatFits)
            .padding(10)
    }
}
