//
//  LessonGroup+CoreDataClass.swift
//  SibGUTimetable
//
//  Created by Александр Камышев on 27.01.2020.
//  Copyright © 2020 Alexandr. All rights reserved.
//
//

import Foundation
import CoreData

@objc(LessonGroup)
public class LessonGroup: NSManagedObject, Decodable {
    enum CodingKeys: String, CodingKey {
            case lessons
    }
        
    public convenience required init(from decoder: Decoder) throws {
        self.init(context: AppDelegate.backgroundContext)
        
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        let lessonsArray = try values.decode([Lesson].self, forKey: .lessons)
        lessonsArray.forEach { (lesson) in
            self.addToLessons(lesson)
        }
    }
}
