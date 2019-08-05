//
//  TimetableScheduleViewModel.swift
//  SibGUTimetable
//
//  Created by Alexandr on 11/07/2019.
//  Copyright © 2019 Alexandr. All rights reserved.
//

import Foundation
import os

class TimetableScheduleViewModel {
    
    private let schedule: Schedule
    let groupName: String
    
//    private orderedDays
    
    #if DEBUG
    static func TESTScheduleViewModel() -> TimetableScheduleViewModel {
        let json = """
{"group_name": "БПИ16-01", "weeks": [{"days": [{"lessons": [{"name": "ТЕСТИРОВАНИЕ ПРОГРАММНОГО ОБЕСПЕЧЕНИЯ", "type": "Лекция", "office": "корп. Л каб. 316", "teacher": "3354", "start_time": "09:40", "end_time": "11:10"}, {"name": "ТЕСТИРОВАНИЕ ПРОГРАММНОГО ОБЕСПЕЧЕНИЯ", "type": "Лабораторная работа", "office": "корп. Л каб. 303", "teacher": "3354", "start_time": "11:30", "end_time": "13:00"}], "header": "Понедельник", "order": 1}, {"lessons": [{"name": "ТЕОРИЯ АВТОМАТОВ И ФОРМАЛЬНЫХ ЯЗЫКОВ", "type": "Лабораторная работа", "office": "корп. Л каб. 318", "teacher": "536", "start_time": "09:40", "end_time": "11:10"}, {"name": "ТЕОРИЯ АВТОМАТОВ И ФОРМАЛЬНЫХ ЯЗЫКОВ", "type": "Лабораторная работа", "office": "корп. Л каб. 318", "teacher": "536", "start_time": "11:30", "end_time": "13:00"}, {"name": "МАШИННО-ЗАВИСИМЫЕ ЯЗЫКИ ПРОГРАММИРОВАНИЯ", "type": "Лабораторная работа", "office": "корп. Л каб. 303", "teacher": "2862", "start_time": "13:30", "end_time": "15:00"}], "header": "Вторник", "order": 1}, {"lessons": [{"name": "РАЗРАБОТКА КОРПОРАТИВНЫХ ПРИЛОЖЕНИЙ", "type": "Лекция", "office": "корп. Л каб. 318", "teacher": "1397", "start_time": "11:30", "end_time": "13:00"}, {"name": "РАЗРАБОТКА КОРПОРАТИВНЫХ ПРИЛОЖЕНИЙ", "type": "Лабораторная работа", "office": "корп. Л каб. 318", "teacher": "1397", "start_time": "13:30", "end_time": "15:00"}, {"name": "ПРОФЕССИОНАЛЬНО-ПРИКЛАДНАЯ ФИЗИЧЕСКАЯ КУЛЬТУРА", "type": "Практика", "office": "корп. ДВС каб. 0", "teacher": "1987", "start_time": "15:10", "end_time": "16:40"}], "header": "Среда", "order": 1}, {"lessons": [{"name": "ПРОЕКТИРОВАНИЕ ЧЕЛОВЕКО-МАШИННОГО ИНТЕРФЕЙСА", "type": "Лабораторная работа", "office": "корп. Л каб. 315", "teacher": "402", "start_time": "09:40", "end_time": "11:10"}, {"name": "ПРОЕКТИРОВАНИЕ ЧЕЛОВЕКО-МАШИННОГО ИНТЕРФЕЙСА", "type": "Лабораторная работа", "office": "корп. Л каб. 315", "teacher": "402", "start_time": "11:30", "end_time": "13:00"}, {"name": "ПЕРИФЕРИЙНЫЕ УСТРОЙСТВА ЭВМ", "type": "Лабораторная работа", "office": "корп. Л каб. 315", "teacher": "402", "start_time": "13:30", "end_time": "15:00"}, {"name": "РАЗРАБОТКА И АНАЛИЗ ТРЕБОВАНИЙ", "type": "Лабораторная работа", "office": "корп. Л каб. 315", "teacher": "536", "start_time": "15:10", "end_time": "16:40"}], "header": "Пятница", "order": 1}, {"lessons": [], "header": "", "order": 1}, {"lessons": [], "header": "", "order": 1}, {"lessons": [], "header": "", "order": 1}], "number_week": 1}, {"days": [{"lessons": [{"name": "ПЕРИФЕРИЙНЫЕ УСТРОЙСТВА ЭВМ", "type": "Лекция", "office": "корп. Л каб. 319", "teacher": "402", "start_time": "09:40", "end_time": "11:10"}, {"name": "ПЕРИФЕРИЙНЫЕ УСТРОЙСТВА ЭВМ", "type": "Лекция", "office": "корп. Л каб. 319", "teacher": "402", "start_time": "11:30", "end_time": "13:00"}, {"name": "ТЕХНИЧЕСКИЙ ПЕРЕВОД В ОБЛАСТИ ИНФОКОММУНИКАЦИОННЫХ ТЕХНОЛОГИЙ", "type": "Практика", "office": "корп. Н каб. 211", "teacher": "1576", "start_time": "13:30", "end_time": "15:00"}, {"name": "ТЕХНИЧЕСКИЙ ПЕРЕВОД В ОБЛАСТИ ИНФОКОММУНИКАЦИОННЫХ ТЕХНОЛОГИЙ", "type": "Практика", "office": "корп. Н каб. 211", "teacher": "1576", "start_time": "15:10", "end_time": "16:40"}], "header": "Понедельник", "order": 1}, {"lessons": [{"name": "БЕЗОПАСНОСТЬ ЖИЗНЕДЕЯТЕЛЬНОСТИ", "type": "Практика", "office": "корп. С каб. 239", "teacher": "3706", "start_time": "13:30", "end_time": "15:00"}, {"name": "БЕЗОПАСНОСТЬ ЖИЗНЕДЕЯТЕЛЬНОСТИ", "type": "Лабораторная работа", "office": "корп. С каб. 239", "teacher": "3706", "start_time": "15:10", "end_time": "16:40"}], "header": "Вторник", "order": 1}, {"lessons": [{"name": "РАЗРАБОТКА КОРПОРАТИВНЫХ ПРИЛОЖЕНИЙ", "type": "Лабораторная работа", "office": "корп. Л каб. 318", "teacher": "1397", "start_time": "09:40", "end_time": "11:10"}, {"name": "РАЗРАБОТКА КОРПОРАТИВНЫХ ПРИЛОЖЕНИЙ", "type": "Лабораторная работа", "office": "корп. Л каб. 318", "teacher": "1397", "start_time": "11:30", "end_time": "13:00"}, {"name": "БЕЗОПАСНОСТЬ ЖИЗНЕДЕЯТЕЛЬНОСТИ", "type": "Лекция", "office": "корп. Л каб. 319", "teacher": "3706", "start_time": "13:30", "end_time": "15:00"}, {"name": "ПРОФЕССИОНАЛЬНО-ПРИКЛАДНАЯ ФИЗИЧЕСКАЯ КУЛЬТУРА", "type": "Практика", "office": "корп. ДВС каб. 0", "teacher": "1987", "start_time": "15:10", "end_time": "16:40"}], "header": "Среда", "order": 1}, {"lessons": [{"name": "МАШИННО-ЗАВИСИМЫЕ ЯЗЫКИ ПРОГРАММИРОВАНИЯ", "type": "Лабораторная работа", "office": "корп. Л каб. 303", "teacher": "2862", "start_time": "13:30", "end_time": "15:00"}, {"name": "МАШИННО-ЗАВИСИМЫЕ ЯЗЫКИ ПРОГРАММИРОВАНИЯ", "type": "Лекция", "office": "корп. Л каб. 316", "teacher": "2862", "start_time": "15:10", "end_time": "16:40"}], "header": "Пятница", "order": 1}, {"lessons": [{"name": "ТЕОРИЯ АВТОМАТОВ И ФОРМАЛЬНЫХ ЯЗЫКОВ", "type": "Лекция", "office": "корп. Л каб. 316", "teacher": "536", "start_time": "09:40", "end_time": "11:10"}, {"name": "ТЕОРИЯ АВТОМАТОВ И ФОРМАЛЬНЫХ ЯЗЫКОВ", "type": "Практика", "office": "корп. Л каб. 303", "teacher": "536", "start_time": "11:30", "end_time": "13:00"}], "header": "Суббота", "order": 1}, {"lessons": [], "header": "", "order": 1}, {"lessons": [], "header": "", "order": 1}], "number_week": 2}]}
"""
        var data = json.data(using: .utf8)!
        let decoder = JSONDecoder()
        let schedule = try! decoder.decode(Schedule.self, from: data)
        
        return TimetableScheduleViewModel(schedule: schedule)!
    }
    #endif
    
    init?(schedule: Schedule) {
        guard let groupName = schedule.group_name, let weeks = schedule.weeks else {
            Logger.logMessage(error: TimetableError.anotherError)
            return nil
        }
        
        self.schedule = schedule
        self.groupName = groupName
        
        //Organize days for display in page view schedule.
        
    }
    
    var countOfDays: Int {
        var daysSum = 0
        
        schedule.weeks?.forEach({ (week) in
            daysSum += (week as! Week).days!.count
        })
        
        return daysSum
    }
    
    func day(at index: Int) -> Day {
        var dayNumber = index % countOfDays
        var numberOfWeek = 0
        
        if (dayNumber - 6) > 0 {
            numberOfWeek = 1
            dayNumber -= 6
        }
        
        let day = (schedule.weeks![numberOfWeek] as! Week).days![dayNumber] as! Day
        return day
    }
    
    
    func dayViewModel(at index: Int) -> TimetableDayViewModel {
        return TimetableDayViewModel(day: day(at: index))
    }
    
}
