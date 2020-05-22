//
//  Formatter.swift
//  colour-run-map
//
//  Created by Kris Skierniewski on 12/05/2020.
//  Copyright © 2020 Kris Skierniewski. All rights reserved.
//

import Foundation
import CoreLocation
import MapKit

class PaceHelper {
    static func paceString(distance: CLLocationDistance, startDate: Date, endDate: Date = Date()) -> String {
        let pace = Self.calculatePace(distance: distance,
                                      start: startDate,
                                      end: endDate)
        
        return String(format: "%@/km", Self.paceFormatter.string(from: pace) ?? "-")
    }
    
    static func paceString(pace: TimeInterval) -> String {
        return String(format: "%@/km", Self.paceFormatter.string(from: pace) ?? "-")
    }
    
    static func calculatePace(distance: CLLocationDistance, start: Date, end: Date) -> TimeInterval {
        return Self.calculatePace(distance: distance, duration: abs(start.timeIntervalSince(end)))
    }
    
    static func calculatePace(distance: CLLocationDistance, duration: TimeInterval) -> TimeInterval {
        let pace = duration / (distance / 1000)
        return pace.isInfinite || pace.isNaN ? 0 : pace
    }
    
    private static var paceFormatter: DateComponentsFormatter {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.unitsStyle = .positional
        return formatter
    }
}
