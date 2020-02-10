//
//  DataManagerTests.swift
//  SibGUTimetableTests
//
//  Created by Александр Камышев on 29.01.2020.
//  Copyright © 2020 Alexandr. All rights reserved.
//

import XCTest
import CoreData

@testable import SibGUTimetable

class DataManagerTests: XCTestCase {
    
    var dataManager: TimetableDataManager!
    
    lazy var mockPersistantContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: "PersistentTimetable", managedObjectModel: self.managedObjectModel)
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

    override func setUp() {
        dataManager = .init(localRepository: CoreDataTTRepository(persistentConstainer: mockPersistantContainer, context: AppDelegate.backgroundContext),
                            serverRepository: ServerRepository())
    }

    override func tearDown() {
        dataManager = nil
    }
    
    func test_update_timetable_check() {
        test_update_timetable()
        test_update_timetable()
        test_update_timetable()
        test_update_timetable()
        test_update_timetable()
        test_update_timetable()
        test_print_all_timetables()
        test_updateTimetable_and_check_newest_returned_timetable()
    }
    
    func test_update_timetable() -> TimeInterval {
        let exp = expectation(description: "update was loaded")
        var timestamp: TimeInterval = .zero
        dataManager.updateTimetable(groupId: 740, groupName: "БПИ16-01").subscribe(onNext: { (timetable) in
            exp.fulfill()
            timestamp = timetable.updateTimestampTime
            print("newTimestamp:", timetable.updateTimestampTime)
        }, onError: nil, onCompleted: nil, onDisposed: nil)
        
        wait(for: [exp], timeout: 30.0)
        return timestamp
    }
    
    func test_print_all_timetables() {
        let repo = CoreDataTTRepository(persistentConstainer: mockPersistantContainer, context: AppDelegate.backgroundContext)
        
        let exp = expectation(description: "printed all timetables")
        repo.fetchAll().subscribe(onSuccess: { (timetables) in
            timetables.forEach { (timetable) in
                print("---------------", timetable.updateTimestampTime)
            }
            exp.fulfill()
        }, onError: { error in
            print(error.localizedDescription)
        })
        wait(for: [exp], timeout: 30.0)
    }
    
    func test_updateTimetable_and_check_newest_returned_timetable() {
        let exp = expectation(description: "was loaded")
        let newTimestamp = test_update_timetable()
        
//        dataManager.deleteAll()
        dataManager.fetchTimetable(groupId: 740, groupName: "БПИ16-01").subscribe(onNext: { (timetable) in
            exp.fulfill()
            XCTAssertEqual(timetable.updateTimestampTime, newTimestamp)
            print("fetched timestamp:", timetable.updateTimestampTime)
        }, onError: nil, onCompleted: nil, onDisposed: nil)

        wait(for: [exp], timeout: 50.0)
    }
}
