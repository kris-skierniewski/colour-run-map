//
//  DateExtensions.swift
//  colour-run-map
//
//  Created by Luke on 12/05/2020.
//  Copyright © 2020 Kris Skierniewski. All rights reserved.
//

import Foundation

public extension Date {
    
    func mwFormatted(_ format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
    
    // MARK: - Vars
    /// The date with seconds forced to 0
    var mwRemoveSeconds: Date {
        let calendar = Calendar.current
        let componentsWithoutSeconds = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: self)
        return calendar.date(from: componentsWithoutSeconds) ?? self
    }
    
    /// Only the year, month and day of a date
    var mwRemoveTimeComponents: Date {
        let calendar = Calendar.current
        let selfDateComponents = calendar.dateComponents([.year, .month, .day], from: self)
        return calendar.date(from: selfDateComponents) ?? self
    }
    
    /// The date as a string with format HH:mm
    var mwShortTimeString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        dateFormatter.locale = Locale(identifier: "en")
        return dateFormatter.string(from: self)
    }
    
    /// The date as a localized string with format HH:mm
    var mwLocalizedShortTimeString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter.string(from: self)
    }
    
    /// The date as a string with format dd/MM/yyyy
    var mwDateString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        dateFormatter.locale = Locale(identifier: "en")
        return dateFormatter.string(from: self)
    }
    
    /// The day of the Date, Monday, Tuesday, Etc
    var mwLocalizedDayString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.string(from: self)
    }
    
    /// The day of the Date, Mon, Tue, Etc
    var mwLocalizedDayShortString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "E"
        return dateFormatter.string(from: self)
    }
    
    /// The day of a date localised with today, tomorrow, or mwAsDayString
    var mwLocalizedDayDescription: String {
        let selfDate = mwRemoveTimeComponents
        let currentDate = Date().mwRemoveTimeComponents
        let tomorrowDate = currentDate.addingTimeInterval(TimeInterval.dayInSeconds).mwRemoveTimeComponents
        
        if selfDate == currentDate {
            return "Today"
        } else if selfDate == tomorrowDate {
            return "Tomorrow"
        } else {
            return mwLocalizedDayString
        }
    }
    
    func timeString(until date: Date) -> String {
        let calendar = Calendar(identifier: .gregorian)
        let components = calendar.dateComponents([.hour, .minute, .second], from: self, to: date)
        return String(format: "%02d:%02d:%02d", components.hour ?? 00, components.minute ?? 00, components.second ?? 00)
    }
}
