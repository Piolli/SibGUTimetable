//
//  CalendarViewModel.swift
//  SibGUTimetable
//
//  Created by Alexandr on 30/06/2019.
//  Copyright © 2019 Alexandr. All rights reserved.
//

import Foundation

class CalendarViewModel {
    
    var months: [CalendarParser.CalendarMonth] {
        return CalendarParser.shared.months
    }
    
    func countOfMonths() -> Int {
        return CalendarParser.shared.months.count
    }
    
    func monthIndexOfCurrentDate() -> Int {
        return CalendarParser.shared.today.monthIndex - 1
    }
    
    func calendarPageViewModelFor(index: Int) -> CalendarPageViewModel {
        return CalendarPageViewModel(pageIndex: index, month: months[index])
    }
    
}
