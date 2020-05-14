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
    
    /// Distance as a whole number with units (for milestone pins on the map)
    var mwKilometersRoundedDown0dp: String {
        return String(format: "%.0f km", floor(self) / 1000)
    }
    
    /// Distance to 2 d.p. with km suffix, rounded down
    var mwKilometersRoundedDown2dp: String {
        return String(format: "%.2f km", floor(self / 10) / 100)
    }
}
