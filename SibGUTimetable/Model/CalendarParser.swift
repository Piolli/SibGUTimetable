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
    }
    
    struct CalendarDay {
        let monthIndex: Int
        let dayInMonth: Int
    }
    
    let calendar = Calendar(identifier: .iso8601)
    
    let today: CalendarDay
    
    
    var months: [CalendarMonth] = []
    
    var date = Date()
    
    //Return the number of week as a number like 0 or 1
    var currentNumberOfWeek: Int {
        //        let date = Date()
//        let dateComponents = calendar.dateComponents(in: .current, from: date)
//
//        let numberWeekOfYear = dateComponents.weekOfYear!
//
//        return numberWeekOfYear
        return 0
    }
    
    //Return the number of day in week like 'monday' = 0, 'tuesday' = 1
    var currentDayOfWeek: Int {
        //        let date = Date()
//        let dateComponents = calendar.dateComponents(in: .current, from: date)
//
//        return dateComponents.weekday! // 4
        
        return calendar.dateComponents([.weekdayOrdinal], from: Date()).weekdayOrdinal!
    }
    
    
    
    
    
    //TD: refactor
    private init() {
        
        let today = Date()
        
        let todayComponents = calendar.dateComponents(in: .current, from: today)
        let month = todayComponents.month!
        let monthName = calendar.monthSymbols[month-1]
        let day = todayComponents.day!
        //        print("Month: \(month) \(monthName) day: \(day)")
        
        let range = calendar.range(of: .day, in: .month, for: today)
        //        print("Month: \(range?.count)")
        
        self.today = CalendarDay(monthIndex: month, dayInMonth: day)
        
        
        for i in calendar.monthSymbols.indices {
            let date = Calendar.current.date(from: DateComponents(year: todayComponents.year!, month: i+1))!
            
            let countDays = calendar.range(of: .day, in: .month, for: date)!.count
            
            let month = CalendarMonth(name: calendar.monthSymbols[i], index: i+1, countDays: countDays)
            
            months.append(month)
        }
        
        dump(months)
        dump(self.today)
    }
    
    
    
}
