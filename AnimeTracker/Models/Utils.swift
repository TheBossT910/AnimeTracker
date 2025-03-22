//
//  Utils.swift
//  AnimeTracker
//
//  Created by Taha Rashid on 2025-03-20.
//  Utility Functions

import Foundation

// Replaces HTML tags with plain text
// courtesy of https://stackoverflow.com/questions/74321827/html-text-to-plain-text-swift
extension String {
    func toPlainText() -> String {
        self.replacingOccurrences(of: #"<[^>]+>"#, with: "", options: .regularExpression)
    }
}

// gets the weekday (String) and returns its number representation
public func getWeekdayAsNumber(weekday: String) -> Int {
    switch weekday {
        case "Sundays"
            : return 0
        case "Mondays"
            : return 1
        case "Tuesdays"
            : return 2
        case "Wednesdays"
            : return 3
        case "Thursdays"
            : return 4
        case "Fridays"
            : return 5
        case "Saturdays"
            : return 6
        default:
            print("Error! Invalid weekday!")
            return -1
    }
}

// function courtesy of ChatGPT.
// TODO: create your own implementation
// gets the weekday range (start and end) as Unix time
// Weekday is a number representation of the weekday, where 0 is Sunday and 6 is Saturday
// week is a Date object representing the currently selected week we want to retrieve the weekday range for
public func getUnixRangeForWeekday(weekday: Int, week: Date) -> (start: TimeInterval, end: TimeInterval)? {
    // TODO: we want to be able to pass in a date object directly and replace currentDate with it
    let calendar = Calendar.current
//    let currentDate = Date()
    let currentDate = week
    
    // Get the current weekday
    let currentWeekday = calendar.component(.weekday, from: currentDate) // Sunday = 1, Monday = 2, ..., Saturday = 7
    
    // Calculate the difference in days between current weekday and target weekday
    let dayDifference = (weekday - currentWeekday + 7) % 7 // Ensures that dayDifference is always positive
    
    // Get the current week's weekday at 00:00 (start of the day)
    guard let startOfDay = calendar.date(byAdding: .day, value: dayDifference, to: currentDate) else {
        return nil
    }
    
    let startOfDayAtMidnight = calendar.startOfDay(for: startOfDay) // Midnight (00:00)
    
    // Calculate the end of the day (23:59:59) for the given weekday
    guard let endOfDay = calendar.date(byAdding: .second, value: 86399, to: startOfDayAtMidnight) else {
        return nil
    }
    
    // Convert start and end dates to Unix timestamps
    let startUnix = startOfDayAtMidnight.timeIntervalSince1970
    let endUnix = endOfDay.timeIntervalSince1970
    
    return (start: startUnix, end: endUnix)
}
