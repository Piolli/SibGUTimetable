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
        guard let context = decoder.userInfo[CodingUserInfoKey.context!] as? NSManagedObjectContext else {
            fatalError("Doesn't provide NSManagedObjectContext for CoreData Object")
        }
        
        self.init(context: context)
        
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        let lessonsArray = try values.decode([Lesson].self, forKey: .lessons)
        lessonsArray.forEach { (lesson) in
            self.addToLessons(lesson)
        }
    }
}
