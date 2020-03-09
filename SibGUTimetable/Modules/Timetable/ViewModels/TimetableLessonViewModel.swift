//
//  TimetableLessonViewModel.swift
//  SibGUTimetable
//
//  Created by Alexandr on 11/07/2019.
//  Copyright © 2019 Alexandr. All rights reserved.
//

import Foundation

class TimetableLessonViewModel {
    
    private let lesson: Lesson
    
    init(lesson: Lesson) {
        self.lesson = lesson
    }
    
    var title: String {
        return "\(lesson.name!) (\(lesson.office!), \(lesson.type!))"
    }
    
    var lessonName: String {
        return lesson.name ?? ""
    }
    
    var timeRange: String {
        return "\(startTime)\n\(endTime)"
    }
    
    var startTime: String {
        return lesson.start_time ?? ""
    }
    
    var endTime: String {
        return lesson.end_time ?? ""
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

