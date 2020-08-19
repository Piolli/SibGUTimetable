//
//  LessonGroup+CoreDataProperties.swift
//  SibGUTimetable
//
//  Created by Александр Камышев on 27.01.2020.
//  Copyright © 2020 Alexandr. All rights reserved.
//
//

import Foundation
import CoreData


extension LessonGroup {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<LessonGroup> {
        return NSFetchRequest<LessonGroup>(entityName: "LessonGroup")
    }

    @NSManaged public var lessons: NSOrderedSet?

}

// MARK: Generated accessors for lessons
extension LessonGroup {

    @objc(insertObject:inLessonsAtIndex:)
    @NSManaged public func insertIntoLessons(_ value: Lesson, at idx: Int)

    @objc(removeObjectFromLessonsAtIndex:)
    @NSManaged public func removeFromLessons(at idx: Int)

    @objc(insertLessons:atIndexes:)
    @NSManaged public func insertIntoLessons(_ values: [Lesson], at indexes: NSIndexSet)

    @objc(removeLessonsAtIndexes:)
    @NSManaged public func removeFromLessons(at indexes: NSIndexSet)

    @objc(replaceObjectInLessonsAtIndex:withObject:)
    @NSManaged public func replaceLessons(at idx: Int, with value: Lesson)

    @objc(replaceLessonsAtIndexes:withLessons:)
    @NSManaged public func replaceLessons(at indexes: NSIndexSet, with values: [Lesson])

    @objc(addLessonsObject:)
    @NSManaged public func addToLessons(_ value: Lesson)

    @objc(removeLessonsObject:)
    @NSManaged public func removeFromLessons(_ value: Lesson)

    @objc(addLessons:)
    @NSManaged public func addToLessons(_ values: NSOrderedSet)

    @objc(removeLessons:)
    @NSManaged public func removeFromLessons(_ values: NSOrderedSet)

}
