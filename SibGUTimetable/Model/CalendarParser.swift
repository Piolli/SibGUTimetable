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
    
    var months: [CalendarMonth] = []
    
    let today: CalendarDay
    
    //TD: refactor
    private init() {
        
        let today = Date()
        
        let calendar = Calendar.current
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
