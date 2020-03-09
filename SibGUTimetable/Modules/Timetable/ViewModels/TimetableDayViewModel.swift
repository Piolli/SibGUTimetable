//
//  TimetableDayViewModel.swift
//  SibGUTimetable
//
//  Created by Alexandr on 11/07/2019.
//  Copyright © 2019 Alexandr. All rights reserved.
//

import Foundation

class TimetableDayViewModel {
    
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
        return day.lessonGroups?.count ?? 0
    }
    
    func lessonViewModel(at indexPath: IndexPath) -> TimetableLessonViewModel? {
        //TODO make to 'LessonGroup'
        let lessonGroup = day.lessonGroups?.array[indexPath.row] as! LessonGroup
        if let firstLessons = lessonGroup.lessons?.firstObject as? Lesson {
            return TimetableLessonViewModel(lesson: firstLessons)
        }
        return nil
    }
    
}
