//
//  MockHelper.swift
//  colour-run-map
//
//  Created by Luke on 26/05/2020.
//  Copyright © 2020 Kris Skierniewski. All rights reserved.
//

import Foundation
import CoreLocation
import SwiftUI

class MockHelper {
    
    static let mockContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    static let location1 = CLLocation(coordinate: CLLocationCoordinate2D(latitude: 36.063457, longitude: -95.880516),
                                 altitude: CLLocationDistance(exactly: 0.0)!,
                                 horizontalAccuracy: CLLocationAccuracy(exactly: 1)!,
                                 verticalAccuracy: CLLocationAccuracy(exactly: 1)!,
                                 timestamp: Date())
    
    static let location2 = CLLocation(coordinate: CLLocationCoordinate2D(latitude: 36.063457, longitude: -95.980516),
                                 altitude: CLLocationDistance(exactly: 0.0)!,
                                 horizontalAccuracy: CLLocationAccuracy(exactly: 1)!,
                                 verticalAccuracy: CLLocationAccuracy(exactly: 1)!,
                                 timestamp: Date().addingTimeInterval(.minuteInSeconds))
    
    static let location3 = CLLocation(coordinate: CLLocationCoordinate2D(latitude: 36.063457, longitude: -96.180516),
                                 altitude: CLLocationDistance(exactly: 0.0)!,
                                 horizontalAccuracy: CLLocationAccuracy(exactly: 1)!,
                                 verticalAccuracy: CLLocationAccuracy(exactly: 1)!,
                                 timestamp: Date().addingTimeInterval(.minuteInSeconds * 2))
    
    static let mockLocations: [CLLocation] = [location1, location2, location3]
    
    static var mockActivity: Activity {
        let mockActivity = Activity.init(context: mockContext)
        mockActivity.createdAt = Date()
        mockActivity.locations = mockLocations
        
        return mockActivity
    }
    
    static var mockAnnotation: ActivityAnnotation {
        let mockAnnotation = ActivityAnnotation(segment: MockHelper.mockActivity.segments.first!)
        mockAnnotation.title = "Sample"
        
        return mockAnnotation
    }
}
