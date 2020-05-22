//
//  Location+CoreDataClass.swift
//  colour-run-map
//
//  Created by Kris Skierniewski on 12/05/2020.
//  Copyright © 2020 Kris Skierniewski. All rights reserved.
//
//

import Foundation
import CoreData
import CoreLocation

public class Activity: NSManagedObject, Identifiable {

    var pace: TimeInterval {
        let pace = PaceHelper.calculatePace(distance: distance,
                                            start: createdAt,
                                            end: createdAt.addingTimeInterval(duration))
        return pace.isInfinite || pace.isNaN ? 0 : pace
    }
    
    var duration: TimeInterval {
        guard let first = locations.first, let last = locations.last else { return 0 }
        return abs(first.timestamp.timeIntervalSince(last.timestamp))
    }
    
    var distance: CLLocationDistance {
        return DistanceHelper.sumOfDistances(betweenLocations: locations)
    }
}
