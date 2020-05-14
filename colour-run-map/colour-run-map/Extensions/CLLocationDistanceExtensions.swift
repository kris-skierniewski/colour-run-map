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
    // show distance as a whole number with units (for milestone pins on the map)
    var stringWithUnitsRounded: String {
        return String(format: "%.0f km", floor(self) / 1000)
    }
    
    var stringWithUnits: String {
        return String(format: "%.2f km", floor(self / 10) / 100)
    }
    
    var string: String {
        return String(format: "%.2f", floor(self / 10) / 100)
    }
}
