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
    var segment: Activity.Segement?
    var isStart: Bool
    var isEnd: Bool
    
    var milestoneCoordinate: CLLocation {
        if isStart { return segment!.locations.first! }
        return segment!.locations.last!
    }
    
    init(segment: Activity.Segement?, isStart: Bool = false, isEnd: Bool = false) {
        self.segment = segment
        self.isStart = isStart
        self.isEnd = isEnd
    }
}
