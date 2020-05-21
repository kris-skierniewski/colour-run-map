//
//  ActivityAnnotation.swift
//  colour-run-map
//
//  Created by Kris Skierniewski on 18/05/2020.
//  Copyright © 2020 Kris Skierniewski. All rights reserved.
//

import Foundation
import MapKit

class ActivityAnnotation: MKPointAnnotation {
    var segment: [CLLocation]?
}
