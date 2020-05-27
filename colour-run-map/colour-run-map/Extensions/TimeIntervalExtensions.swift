//
//  TimeIntervalExtensions.swift
//  colour-run-map
//
//  Created by Luke on 12/05/2020.
//  Copyright © 2020 Kris Skierniewski. All rights reserved.
//

import Foundation

public extension TimeInterval {
    
    static var minuteInSeconds: TimeInterval = 60
    static var hourInSeconds: TimeInterval = 3600
    static var dayInSeconds: TimeInterval = 86400
    static var weekInSeconds: TimeInterval = 604800
    
    /// A String of the time interval in minutes, rounded to the nearest whole minute,
    /// with appropriate mins / min suffix
    var mwRoundedMinutesString: String {
        return "\(mwMinutesRounded) \(mwMinutesRounded == 1 ? "min" : "mins")"
    }
    
    /// A String of the time interval in the format 0h 0m(s) or 0min(s)
    /// Minutes are rounded to the nearest whole minute
    var mwRoundedHourMinutesString: String {
        let hours = Int(floor(Double(mwMinutesRounded) / TimeInterval.minuteInSeconds))
        let remainingMinutes = mwMinutesRounded % Int(TimeInterval.minuteInSeconds)
        if hours > 0 {
            let hourString = hours == 1 ? "hour" : "hours"
            return remainingMinutes > 0 ?
                "\(hours)h \(remainingMinutes)m" :
                "\(hours) \(hourString)"
        } else {
            return mwRoundedMinutesString
        }
    }

    /// An Int of the time interval in minutes to the nearest whole minute
    var mwMinutesRounded: Int { return Int((self/TimeInterval.minuteInSeconds).rounded()) }
    
    /// An Int of the time interval in minutes floored
    var mwMinutesFloored: Int { return Int(floor(self/TimeInterval.minuteInSeconds)) }
    
    var asString: String {
        let interval = Int(self)
        let seconds = interval % 60
        let minutes = (interval / 60) % 60
        let hours = (interval / 3600)
        
        if hours > 0 {
            return String(format: "%01d:%02d:%02d", hours, minutes, seconds)
        } else {
            return String(format: "%02d:%02d", minutes, seconds)
        }
    }
}
