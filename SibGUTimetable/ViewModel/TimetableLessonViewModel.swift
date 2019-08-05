//
//  TimetableLessonViewModel.swift
//  SibGUTimetable
//
//  Created by Alexandr on 11/07/2019.
//  Copyright © 2019 Alexandr. All rights reserved.
//

import Foundation

class TimetableLessonViewModel {
    
    let lesson: Lesson
    
    init(lesson: Lesson) {
        self.lesson = lesson
    }
    
    var title: String {
        return "\(lesson.name!) (\(lesson.office!), \(lesson.type!))"
    }
    
    var timeRange: String {
        return "\(lesson.start_time!) – \(lesson.end_time!)"
    }
    
    var typeLesson: String {
        return "\(lesson.type!)"
    }
    
    var office: String {
        return "\(lesson.office!)"
    }
    
    var teacher: String {
        return "\(lesson.teacher!)"
    }
    
}

