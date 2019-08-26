//
//  CalendarPageViewModel.swift
//  SibGUTimetable
//
//  Created by Alexandr on 30/06/2019.
//  Copyright © 2019 Alexandr. All rights reserved.
//

import Foundation

class CalendarPageViewModel {
    
    let month: CalendarParser.CalendarMonth
    let pageIndex: Int
    
    init(pageIndex: Int, month: CalendarParser.CalendarMonth) {
        self.month = month
        self.pageIndex = pageIndex
    }
    
    var emptyLeadingDaysCount: Int {
        let startOfMonthDate = month.toDate(withDay: 1)
        return CalendarParser.shared.currentDayOfWeek(date: startOfMonthDate)
    }
    
    var countOfLeadingAndMonthDays: Int {
        return emptyLeadingDaysCount + month.countDays
    }
    
    func indexPathIsMonthDay(indexPath: IndexPath) -> Bool {
        return (indexPath.row + 1) > emptyLeadingDaysCount
    }
    
    func dayNumber(for indexPath: IndexPath) -> String {
        return "\(indexPath.row - emptyLeadingDaysCount + 1)"
    }
}
