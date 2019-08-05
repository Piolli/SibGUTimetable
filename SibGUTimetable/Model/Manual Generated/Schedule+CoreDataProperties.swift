//
//  Schedule+CoreDataProperties.swift
//  SibGUTimetable
//
//  Created by Alexandr on 01/08/2019.
//  Copyright © 2019 Alexandr. All rights reserved.
//
//

import Foundation
import CoreData


extension Schedule {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Schedule> {
        return NSFetchRequest<Schedule>(entityName: "Schedule")
    }

    @NSManaged public var group_name: String?
    @NSManaged public var weeks: NSOrderedSet?

}

// MARK: Generated accessors for weeks
extension Schedule {

    @objc(insertObject:inWeeksAtIndex:)
    @NSManaged public func insertIntoWeeks(_ value: Week, at idx: Int)

    @objc(removeObjectFromWeeksAtIndex:)
    @NSManaged public func removeFromWeeks(at idx: Int)

    @objc(insertWeeks:atIndexes:)
    @NSManaged public func insertIntoWeeks(_ values: [Week], at indexes: NSIndexSet)

    @objc(removeWeeksAtIndexes:)
    @NSManaged public func removeFromWeeks(at indexes: NSIndexSet)

    @objc(replaceObjectInWeeksAtIndex:withObject:)
    @NSManaged public func replaceWeeks(at idx: Int, with value: Week)

    @objc(replaceWeeksAtIndexes:withWeeks:)
    @NSManaged public func replaceWeeks(at indexes: NSIndexSet, with values: [Week])

    @objc(addWeeksObject:)
    @NSManaged public func addToWeeks(_ value: Week)

    @objc(removeWeeksObject:)
    @NSManaged public func removeFromWeeks(_ value: Week)

    @objc(addWeeks:)
    @NSManaged public func addToWeeks(_ values: NSOrderedSet)

    @objc(removeWeeks:)
    @NSManaged public func removeFromWeeks(_ values: NSOrderedSet)

}
