//
//  CLLocationDistanceExtensions.swift
//  colour-run-map
//
//  Created by Luke on 12/05/2020.
//  Copyright © 2020 Kris Skierniewski. All rights reserved.
//

import Foundation
import CoreLocation
import MapKit

extension CLLocationDistance {
    private var distanceFormatter: MKDistanceFormatter {
        let formatter = MKDistanceFormatter()
        formatter.units = .metric
        formatter.unitStyle = .abbreviated
        return formatter
    }
    
    var formattedDistanceString: String {
        return distanceFormatter.string(fromDistance: self)
    }
}
