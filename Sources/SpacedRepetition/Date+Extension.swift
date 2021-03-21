//
//  Date+Extension.swift
//  
//
//  Created by Michael Charland on 2021-03-20.
//

import Foundation

extension Date {

    func isAfterToday() -> Bool {
        let hour = Calendar.current.component(.hour, from: Date())
        let hoursLeftInDay = 24 - hour
        let secondsUntilTomorrow = TimeInterval(hoursLeftInDay * 60 * 60)
        let tomorrow = Date(timeIntervalSinceNow: secondsUntilTomorrow)
        if compare(tomorrow) == .orderedDescending {
            return true
        }
        return false
    }
}
