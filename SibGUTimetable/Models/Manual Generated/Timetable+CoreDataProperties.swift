//
//  Timetable+CoreDataProperties.swift
//  SibGUTimetable
//
//  Created by Александр Камышев on 13.09.2020.
//  Copyright © 2020 Alexandr. All rights reserved.
//
//

import Foundation
import CoreData


extension Timetable {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Timetable> {
        return NSFetchRequest<Timetable>(entityName: "Timetable")
    }

    @NSManaged public var group_name: String?
    @NSManaged public var updateTimestamp: String?
    @NSManaged public var weeks: NSOrderedSet?

}

// MARK: Generated accessors for weeks
extension Timetable {

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
