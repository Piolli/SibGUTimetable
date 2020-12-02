//
//  Calendar.swift
//  SibGUTimetable
//
//  Created by Alexandr on 30/06/2019.
//  Copyright © 2019 Alexandr. All rights reserved.
//

import Foundation

class CalendarParser {
    
    static let shared = CalendarParser()
    
    struct CalendarMonth {
        let name: String
        let index: Int
        let countDays: Int
        
        func toDate(withDay day: Int) -> Date {
            let cmps = DateComponents(year: CalendarParser.shared.today.year, month: index, day: day)
            return CalendarParser.shared.calendar.date(from: cmps)!
        }
    }
    
    struct CalendarDay {
        let monthIndex: Int
        let dayInMonth: Int
        let year: Int
    }
    
    let calendar = Calendar(identifier: .gregorian)
    let today: CalendarDay
    var months: [CalendarMonth] = []
    var date = Date()
    
    //Return the number of week as a number like 0 or 1
    func currentNumberOfWeek(date: Date = Date()) -> Int {
        let dateComponents = calendar.dateComponents(in: .current, from: date)
        let numberWeekOfYear = dateComponents.weekOfYear!
        let result = numberWeekOfYear % 2
        return result
    }
    
    //Return the number of day in week like 'monday' = 0, 'tuesday' = 1
    func currentDayOfWeek(date: Date = Date()) -> Int {
        let dateComponents = calendar.dateComponents(in: .current, from: date)
        let rawWeekDay = dateComponents.weekday!
        let result = toISOWeekday(weekday: rawWeekDay) - 1
        return result
    }
    
    fileprivate func toISOWeekday(weekday: Int) -> Int {
        switch weekday {
        case 1:
            return 7
        case 2...7:
            return weekday - 1
        default:
            return -1
        }
    }
    
    //TD: refactor
    private init() {
        let today = Date()
        let todayComponents = calendar.dateComponents(in: .current, from: today)
        let month = todayComponents.month!
        let monthName = calendar.monthSymbols[month-1]
        let day = todayComponents.day!
        let range = calendar.range(of: .day, in: .month, for: today)
        self.today = CalendarDay(monthIndex: month, dayInMonth: day, year: todayComponents.year!)
        let monthSymbols = DateFormatter().monthSymbols!
        for i in calendar.monthSymbols.indices {
            let date = Calendar.current.date(from: DateComponents(year: todayComponents.year!, month: i+1))!
            let countDays = calendar.range(of: .day, in: .month, for: date)!.count
            let month = CalendarMonth(name: monthSymbols[i], index: i+1, countDays: countDays)
            months.append(month)
        }
    }
    
    
    
}
