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
            if locations.indices.contains(index+1) {
                sumOfDistance += location.distance(from: locations[index+1])
            }
        }
        
        return sumOfDistance
    }
    
//    static func groupInChunks(ofLength length: CLLocationDistance,
//                              fromLocations locations: [CLLocation]) -> [[CLLocation]] {
//        var chunks = [[CLLocation]]()
//        
//        var sum: CLLocationDistance = 0
//        var chunkStartIndex: Int = -1
//        
//        locations.enumerated().forEach { (index, location) in
//            if chunkStartIndex == -1 { chunkStartIndex = index }
//            if locations.indices.contains(index+1) {
//                sum += location.distance(from: locations[index+1])
//                
//                if sum >= length {
//                    chunks.append(Array(locations[chunkStartIndex..<index]))
//                    chunkStartIndex = -1
//                    sum = 0
//                }
//            }
//        }
//        
//        return chunks
//    }
}
