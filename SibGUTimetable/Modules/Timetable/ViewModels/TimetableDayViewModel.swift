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
    
    func lessonViewModels(at indexPath: IndexPath) -> [TimetableLessonViewModel]? {
        let lessonGroup = day.lessonGroups?.array[indexPath.row] as! LessonGroup
        return lessonGroup.lessons?.array
            .map { TimetableLessonViewModel(lesson: ($0 as! Lesson)) }
    }
    
}
