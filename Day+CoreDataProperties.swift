//
//  Day+CoreDataProperties.swift
//  SibGUTimetable
//
//  Created by Александр Камышев on 27.01.2020.
//  Copyright © 2020 Alexandr. All rights reserved.
//
//

import Foundation
import CoreData


extension Day {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Day> {
        return NSFetchRequest<Day>(entityName: "Day")
    }

    @NSManaged public var header: String?
    @NSManaged public var order: Int16
    @NSManaged public var lessonGroups: NSOrderedSet?

}

// MARK: Generated accessors for lessonGroups
extension Day {

    @objc(insertObject:inLessonGroupsAtIndex:)
    @NSManaged public func insertIntoLessonGroups(_ value: LessonGroup, at idx: Int)

    @objc(removeObjectFromLessonGroupsAtIndex:)
    @NSManaged public func removeFromLessonGroups(at idx: Int)

    @objc(insertLessonGroups:atIndexes:)
    @NSManaged public func insertIntoLessonGroups(_ values: [LessonGroup], at indexes: NSIndexSet)

    @objc(removeLessonGroupsAtIndexes:)
    @NSManaged public func removeFromLessonGroups(at indexes: NSIndexSet)

    @objc(replaceObjectInLessonGroupsAtIndex:withObject:)
    @NSManaged public func replaceLessonGroups(at idx: Int, with value: LessonGroup)

    @objc(replaceLessonGroupsAtIndexes:withLessonGroups:)
    @NSManaged public func replaceLessonGroups(at indexes: NSIndexSet, with values: [LessonGroup])

    @objc(addLessonGroupsObject:)
    @NSManaged public func addToLessonGroups(_ value: LessonGroup)

    @objc(removeLessonGroupsObject:)
    @NSManaged public func removeFromLessonGroups(_ value: LessonGroup)

    @objc(addLessonGroups:)
    @NSManaged public func addToLessonGroups(_ values: NSOrderedSet)

    @objc(removeLessonGroups:)
    @NSManaged public func removeFromLessonGroups(_ values: NSOrderedSet)

}
