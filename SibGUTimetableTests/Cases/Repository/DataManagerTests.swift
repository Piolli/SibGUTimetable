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
    
    var dataManager: TTDataManager!
    
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
        dataManager = .init(localRepository: CoreDataTTRepository(persistentConstainer: mockPersistantContainer),
                            serverRepository: ServerRepository())
    }

    override func tearDown() {
        dataManager = nil
    }
    
    func test_getTimetable_success() {
        let exp = expectation(description: "was loaded")
//        let saveExp = expectation(description: "save to db")
////        dataManager.deleteAll()
//        let timetable = FileLoader.shared.getLocalSchedule()
//        CoreDataTTRepository(persistentConstainer: self.mockPersistantContainer).saveTimetable(timetable: timetable!).subscribe(onCompleted: {
//            saveExp.fulfill()
//        }, onError: { error in
//            saveExp.fulfill()
//            print("Error:", error.localizedDescription)
//        })
        
        dataManager.localRepository.getTimetable(groupId: 740, groupName: "БПИ16-01").subscribe(onSuccess: { (timetable) in
            exp.fulfill()
        }) { (error) in
            print("ERRPR", error.localizedDescription)
        }
//
//        dataManager.fetchTimetable(groupId: 740, groupName: "БПИ16-01").subscribe(onNext: { (timetable) in
//            print(timetable.group_name)
//        }, onError: { (error) in
//            print(error.localizedDescription)
//        }, onCompleted: {
//            exp.fulfill()
//        }, onDisposed: nil)
//
        wait(for: [exp], timeout: 5.0)
    }
}
