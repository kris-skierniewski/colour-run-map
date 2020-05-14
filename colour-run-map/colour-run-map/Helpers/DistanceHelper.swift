//
//  DistanceHelper.swift
//  colour-run-map
//
//  Created by Luke on 14/05/2020.
//  Copyright © 2020 Kris Skierniewski. All rights reserved.
//

import Foundation
import CoreLocation
import MapKit

class DistanceHelper {
    static func sumOfDistances(betweenLocations locations: [CLLocation]) -> CLLocationDistance {
        var sumOfDistance: CLLocationDistance = 0
        
        locations.enumerated().forEach { (index, location) in
            if locations[index+1] != nil {
                sumOfDistance += location.distance(from: locations[index+1])
            }
        }
        
        return sumOfDistance
    }
}
