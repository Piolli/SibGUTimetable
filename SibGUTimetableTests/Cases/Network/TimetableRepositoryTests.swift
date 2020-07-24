//
//  TimetableRepositoryTests.swift
//  SibGUTimetableTests
//
//  Created by Alexandr on 03.11.2019.
//  Copyright © 2019 Alexandr. All rights reserved.
//

import XCTest
import RxSwift
import CoreData
import RxTest

@testable import SibGUTimetable

class TimetableRepositoryTests: XCTestCase {

    var repository: CoreDataTTRepository!
    let disposeBag = DisposeBag()
    var testScheduler: TestScheduler!
    
    lazy var mockPersistantContainer: NSPersistentContainer = {

        let model = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.managedObjectModel
        XCTAssertNotNil(model)
        let container = NSPersistentContainer(name: "PersistentTimetable", managedObjectModel: model!)
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        description.shouldAddStoreAsynchronously = false // Make it simpler in test env

        container.persistentStoreDescriptions = [description]
        container.loadPersistentStores { (description, error) in
            // Check if the data store is in memory
            precondition( description.type == NSInMemoryStoreType )

            // Check if creating container wrong
            if let error = error {
                fatalError("Create an in-mem coordinator failed \(error)")
            }
        }
        return container
    }()
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        let managedObjectModel = NSManagedObjectModel.mergedModel(from: [Bundle(for: type(of: self))] )!
        return managedObjectModel
    }()
    
    lazy var backgroundContext: NSManagedObjectContext = {
        return mockPersistantContainer.newBackgroundContext()
    }()

    override func setUp() {
        testScheduler = TestScheduler(initialClock: 0)
        repository = CoreDataTTRepository(context: backgroundContext)
    }
    
    override func tearDown() {
        testScheduler = nil
        repository = nil
    }

    func test_add_timetable_valid_data() throws {
        let decoder = JSONDecoder()
        decoder.userInfo[CodingUserInfoKey.context!] = self.backgroundContext
        let timetable = FileLoader.shared.getLocalSchedule(decoder: decoder)
        
        XCTAssertNotNil(timetable)
        ///It true because I've created Timetable on backgroundContext
        XCTAssertTrue(backgroundContext.hasChanges)
        ///There're no anyone changes to main context
        XCTAssertFalse(mockPersistantContainer.viewContext.hasChanges)
        
        repository.save(timetable: timetable!)
        
        let localTimetable = try repository.fetchAll().toBlocking().single()
        
        XCTAssertEqual(timetable, localTimetable)
    }
    
    func timetableWith(timestamp: String) -> Timetable {
        let decoder = JSONDecoder()
        decoder.userInfo[CodingUserInfoKey.context!] = self.backgroundContext
        let timetable = FileLoader.shared.getLocalSchedule(decoder: decoder)
        XCTAssertNotNil(timetable)
        timetable!.updateTimestamp = timestamp
        return timetable!
    }
    
    func test_fetch_newest_timetable_exits() throws {
        let timetables = [
            timetableWith(timestamp: "4"),
            timetableWith(timestamp: "8"),
            timetableWith(timestamp: "3"),
            timetableWith(timestamp: "0"),
            timetableWith(timestamp: "15"),
            timetableWith(timestamp: "2")
        ]
        
        XCTAssertTrue(backgroundContext.hasChanges)
        ///Save context instead of specified Timetable
        repository.save(timetable: timetables[0])

        ///Return the latest Timetable from repository
        let fetchedTimetable = try repository.getTimetable(timetableDetails: TimetableDetails(groupId: 779, groupName: "БПИ16-01")).toBlocking().single()
        
        let expectedTimetable = timetables.max(by: { (t1, t2) -> Bool in
            return t1.updateTimestampTime < t2.updateTimestampTime
        })
        dump(expectedTimetable)
        XCTAssertEqual(fetchedTimetable, expectedTimetable)
        
        
        
    }
    
}
