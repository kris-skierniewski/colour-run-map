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

class Formatter {
    
    var distanceFormatter: MKDistanceFormatter {
        let formatter = MKDistanceFormatter()
        formatter.units = .metric
        formatter.unitStyle = .abbreviated
        return formatter
    }
    
    func dayString(from date: Date) -> String {
        let dateFormatter = DateFormatter()
        //dateFormatter.dateFormat = "dd-MM-yyyy"
        dateFormatter.dateFormat = "EEEE\n dd MMMM"
        return dateFormatter.string(from: date)
    }
    
    func timeString(from date: Date, until now: Date) -> String {
        let calendar = Calendar(identifier: .gregorian)
        let components = calendar.dateComponents([.hour, .minute, .second], from: date, to: now)
        return String(format: "%02d:%02d:%02d", components.hour ?? 00, components.minute ?? 00, components.second ?? 00)
    }
    
    func paceString(distance: CLLocationDistance, start: Date) -> String {
        let seconds = abs(start.timeIntervalSinceNow)
        guard distance > 0.0 else {
            return "-"
        }
        let pace = seconds / (distance / 1000)
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.unitsStyle = .positional
        
        return String(format: "%@/km",formatter.string(from: pace) ?? "-")
    }
    
    func distanceString(from distance: CLLocationDistance) -> String {
        return distanceFormatter.string(fromDistance: distance)
    }
    
    
    
    
}
