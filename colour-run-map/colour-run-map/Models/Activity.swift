//
//  Activity.swift
//  colour-run-map
//
//  Created by Kris Skierniewski on 11/05/2020.
//  Copyright © 2020 Kris Skierniewski. All rights reserved.
//

import SwiftUI
import CoreLocation

struct Activity: Identifiable {
    var id: Int
    var startDate: Date
    var finishDate: Date
    var locations: [CLLocation]
    
    
}
