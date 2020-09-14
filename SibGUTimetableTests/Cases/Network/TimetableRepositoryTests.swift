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
        let container = NSPersistentContainer(name: "PersistentTimetableStore", managedObjectModel: model!)
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
        let context = mockPersistantContainer.newBackgroundContext()
        context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
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
        
        repository.save(timetable: timetable!).subscribe().disposed(by: disposeBag)
        
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
    
    func saveTimetable(_ timetable: Timetable) throws {
        try! repository.save(timetable: timetable).toBlocking().first()
    }
    
    func test_add_duplicated_timetables() throws {
        let timestamps: [TimeInterval] = [4, 4, 1, 15, 4, 2]
        for ts in timestamps {
            try! saveTimetable(timetableWith(timestamp: "\(ts)"))
        }
        //All Objects is saved above
        XCTAssertFalse(backgroundContext.hasChanges)
        
        ///Return the newest Timetable from repository
        let fetchedTimetable = try repository.getTimetable(timetableDetails: TimetableDetails(groupId: 779, groupName: "БПИ16-01")).toBlocking().single()
        let databaseTimetables = try repository.fetchAll().toBlocking().toArray()
        
        //There's only one = newest timetable
        XCTAssertEqual(databaseTimetables.count, 1)
        
        let expectedTimetableTimestamp = timestamps.max(by: <)
        XCTAssertEqual(fetchedTimetable.updateTimestampTime, expectedTimetableTimestamp)
    }
    
}
