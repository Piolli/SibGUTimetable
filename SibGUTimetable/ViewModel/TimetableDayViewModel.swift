//
//  TimetableDayViewModel.swift
//  SibGUTimetable
//
//  Created by Alexandr on 11/07/2019.
//  Copyright © 2019 Alexandr. All rights reserved.
//

import Foundation

class TimetableDayViewModel {
    
    private let day: Day!
    
    var header: String {
        return day.header!
    }
    
    init(day: Day) {
        self.day = day
    }
    
    var countOflessons: Int {
        return day.lessons?.count ?? 0
    }
    
    func lessonViewModel(at indexPath: IndexPath) -> TimetableLessonViewModel {
        let lesson = day.lessons?.array[indexPath.row] as! Lesson
        return TimetableLessonViewModel(lesson: lesson)
    }
    
}
