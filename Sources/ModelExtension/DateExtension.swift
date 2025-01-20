//
//  DateExtension.swift
//
//
//  Created by Kth on 2024-03-07.
//

import Foundation

public extension Date {
    var twentyMinsLater: Date { advanced(by: 20 * 60) }
    var fifteenMinsLater: Date { advanced(by: 15 * 60) }
    var twentyFourHoursAgo: Date { advanced(by: -24 * 60 * 60) }
    var oneHoursAgo: Date { advanced(by: -1 * 60 * 60) }
}

public extension Calendar {
    func startOfTomorrow(for date: Date) -> Date {
        self.date(byAdding: .day, value: 1, to: startOfDay(for: date))!
    }
}

public extension FormatStyle where Self == Date.FormatStyle {
    static var twentyFourHourSystem: Self {
        .dateTime.hour(.twoDigits(amPM: .omitted)).minute(.twoDigits)
    }
}
