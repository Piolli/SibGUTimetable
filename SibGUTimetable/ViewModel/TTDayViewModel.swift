//
//  TimetableDayViewModel.swift
//  SibGUTimetable
//
//  Created by Alexandr on 11/07/2019.
//  Copyright © 2019 Alexandr. All rights reserved.
//

import Foundation

class TTDayViewModel {
    
    private let day: Day
    private(set) var date: Date
    
    var header: String {
        return day.header!
    }
    
    init(day: Day, date: Date) {
        self.day = day
        self.date = date
    }
    
    var countOflessons: Int {
        return day.lessons?.count ?? 0
    }
    
    func lessonViewModel(at indexPath: IndexPath) -> TTLessonViewModel {
        let lesson = day.lessons?.array[indexPath.row] as! Lesson
        return TTLessonViewModel(lesson: lesson)
    }
    
}
