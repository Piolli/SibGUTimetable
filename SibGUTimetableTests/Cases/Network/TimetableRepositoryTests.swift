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

@testable import SibGUTimetable

class TimetableRepositoryTests: XCTestCase {

    var repository: CoreDataTTRepository!
    
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
        repository = CoreDataTTRepository(persistentConstainer: mockPersistantContainer)
    }
    
    override func tearDown() {
        repository = nil
    }

    func test_add_timetable_valid_data() {
        let exp = expectation(description: "was loaded")
        let timetable = FileLoader.shared.getLocalSchedule()
        XCTAssertNotNil(timetable)
        repository.saveTimetable(timetable: timetable!)
        print("before fetch all")
        repository.fetchAll().subscribe(onSuccess: { (ts) in
            dump(ts)
            dump((ts.first?.weeks?.lastObject as? Week)?.order_week)
            exp.fulfill()
        }) { (error) in
            
        }
        print("after fetch all")
        wait(for: [exp], timeout: 3.0)
    }
    
    func test_fetch_timetable_exits() {
        let exp = expectation(description: "was loaded")
        
        let timetable = FileLoader.shared.getLocalSchedule()
        XCTAssertNotNil(timetable)
        repository.saveTimetable(timetable: timetable!)
        
        repository.getTimetable( groupId: 740, groupName: "БПИ16-01").subscribe(onSuccess: { (timetable) in
            exp.fulfill()
            dump((timetable.weeks?.lastObject as? Week)?.order_week)
        }) { (error) in
            print("ERROR:", error)
        }
        
        wait(for: [exp], timeout: 5.0)
    }
    
}
