//
//  TimetableScheduleViewModel.swift
//  SibGUTimetable
//
//  Created by Alexandr on 11/07/2019.
//  Copyright © 2019 Alexandr. All rights reserved.
//

import Foundation
import os

class TimetableViewModel {
    
    let schedule: Timetable
    let groupName: String
    
    init?(schedule: Timetable) {
        guard let groupName = schedule.group_name, let weeks = schedule.weeks else {
            logger.error("Timetable is nil")
            return nil
        }
        
        self.schedule = schedule
        self.groupName = groupName
    }

    var countOfDays: Int {
        return 30 * 4
    }
    
    var startPageViewDate: Date {
        return Date()
    }
    
    func getDay(at date: Date) -> Day {
        let weekIndex = CalendarParser.shared.currentNumberOfWeek(date: date)
        let dayIndex = CalendarParser.shared.currentDayOfWeek(date: date)

        let day = (schedule.weeks![weekIndex] as! Week).days![dayIndex] as! Day
        return day
    }

    func getDayViewModel(at date: Date) -> TimetableDayViewModel {
        return TimetableDayViewModel(day: getDay(at: date), date: date)
    }
    
}

