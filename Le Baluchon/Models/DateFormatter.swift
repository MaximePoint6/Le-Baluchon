//
//  DateFormatter.swift
//  Le Baluchon
//
//  Created by Maxime Point on 17/12/2022.
//

import Foundation

class DateFormater {
    
    static func getDate(timeZone: Int) -> String {
        let currentDate = Date()
        // Create a DateFormatter() object.
        let format = DateFormatter()
        // Set the current timezone to .current, or America/Chicago.
        format.timeZone = TimeZone(secondsFromGMT: timeZone)
        // Set the format of the altered date.
        format.dateFormat = "EEE, d MMM - HH:mm"
        // Set the current date, altered by timezone.
        return format.string(from: currentDate)
    }
    
}
