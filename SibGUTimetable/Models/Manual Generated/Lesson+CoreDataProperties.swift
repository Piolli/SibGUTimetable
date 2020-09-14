//
//  Lesson+CoreDataProperties.swift
//  SibGUTimetable
//
//  Created by Александр Камышев on 13.09.2020.
//  Copyright © 2020 Alexandr. All rights reserved.
//
//

import Foundation
import CoreData


extension Lesson {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Lesson> {
        return NSFetchRequest<Lesson>(entityName: "Lesson")
    }

    @NSManaged public var end_time: String?
    @NSManaged public var name: String?
    @NSManaged public var office: String?
    @NSManaged public var start_time: String?
    @NSManaged public var teacher: String?
    @NSManaged public var type: String?
    @NSManaged public var lessonGroup: LessonGroup?

}
