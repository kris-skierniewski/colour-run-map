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

    public class Segement: Identifiable, Equatable {
        let index: Int
        let locations: [CLLocation]
        
        init(index: Int, locations: [CLLocation]) {
            self.index = index
            self.locations = locations
        }
        
        var distance: CLLocationDistance {
            return DistanceHelper.sumOfDistances(betweenLocations: locations)
        }
        
        var duration: TimeInterval {
            guard let first = locations.first, let last = locations.last else { return 0 }
            return abs(first.timestamp.timeIntervalSince(last.timestamp))
        }
        
        var pace: TimeInterval {
            let pace = PaceHelper.calculatePace(distance: distance, duration: duration)
            return pace.isInfinite || pace.isNaN ? 0 : pace
        }
        
        public static func == (lhs: Activity.Segement, rhs: Activity.Segement) -> Bool {
            return lhs.index == rhs.index && lhs.locations == rhs.locations
        }
    }
    
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
    
    var fastestSegement: Segement {
        return segments.sorted(by: { $0.pace > $1.pace }).first!
    }
    
    var slowestSegement: Segement {
        return segments.sorted(by: { $0.pace > $1.pace }).last!
    }
    
    var segments: [Segement] {
        let subsets = groupLocationsInSubSets(ofDistance: .kilometerInMeters, includeIncompleteSubSet: true)
        var result = [Segement]()
        
        subsets.enumerated().forEach { (index, group) in
            result.append(Segement(index: index, locations: group))
        }
        
        return result
    }
    
    func groupLocationsInSubSets(ofDistance subSetMaxDistance: CLLocationDistance,
                                 includeIncompleteSubSet: Bool = true) -> [[CLLocation]]{
        var groupedSubSets: [[CLLocation]] = []
        var subSetDistance: CLLocationDistance = .zero
        var subSet = [CLLocation]()
        
        self.locations.forEach { location in
            if let previousLocation = subSet.last { subSetDistance += previousLocation.distance(from: location) }
            subSet.append(location)
            
            if subSetDistance >= subSetMaxDistance {
                groupedSubSets.append(subSet)
                subSet = []
                subSetDistance = .zero
            }
        }
        
        if includeIncompleteSubSet && subSet.count > 0 {
            groupedSubSets.append(subSet)
        }
        
        return groupedSubSets
    }
    
    
}
