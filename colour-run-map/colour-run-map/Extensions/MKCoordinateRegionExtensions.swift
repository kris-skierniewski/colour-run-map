//
//  MKCoordinateRegionExtensions.swift
//  colour-run-map
//
//  Created by Kris Skierniewski on 13/05/2020.
//  Copyright © 2020 Kris Skierniewski. All rights reserved.
//

import Foundation
import MapKit

extension MKCoordinateRegion {
    static func enclosingRegion(locations: [CLLocation]) -> MKCoordinateRegion {
        var minLat: CLLocationDegrees = 90.0;
        var maxLat: CLLocationDegrees = -90.0;
        var minLon: CLLocationDegrees = 180.0;
        var maxLon: CLLocationDegrees = -180.0;
        
        for location in locations {
            if location.coordinate.latitude < minLat {
                minLat = location.coordinate.latitude;
            }
            if location.coordinate.longitude < minLon {
                minLon = location.coordinate.longitude
            }
            if location.coordinate.latitude > maxLat {
                maxLat = location.coordinate.latitude
            }
            if location.coordinate.longitude > maxLon {
                maxLon = location.coordinate.longitude
            }
        }
        
        minLat -= 0.001
        maxLat += 0.001
        
        minLon -= 0.001
        maxLon += 0.001
        
        let span = MKCoordinateSpan(latitudeDelta: maxLat - minLat , longitudeDelta: maxLon - minLon)
        let center = CLLocationCoordinate2DMake((maxLat - span.latitudeDelta / 2), maxLon - span.longitudeDelta / 2);
        
        return MKCoordinateRegion(center: center, span: span);
    }
    
    static func regionFor(trackingLocation location: CLLocation) -> MKCoordinateRegion {
        let span = MKCoordinateSpan(latitudeDelta: 0.002, longitudeDelta: 0.002)
        let region = MKCoordinateRegion(center: location.coordinate, span: span)
        return region
    }
    
    static func regionForActivityDetails(atLocation location: CLLocation) -> MKCoordinateRegion {
        let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        let region = MKCoordinateRegion(center: location.coordinate, span: span)
        return region
    }
}

