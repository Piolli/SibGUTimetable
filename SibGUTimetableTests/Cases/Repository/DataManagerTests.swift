//
//  DataManagerTests.swift
//  SibGUTimetableTests
//
//  Created by Александр Камышев on 29.01.2020.
//  Copyright © 2020 Alexandr. All rights reserved.
//

import XCTest
import CoreData
import RxTest
import RxSwift
import RxBlocking


@testable import SibGUTimetable

class DataManagerTests: XCTestCase {
    
    var dataManager: TimetableDataManager!
    var testScheduler: TestScheduler!
    var localRepository: TimetableRepository!
    
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
    
    lazy var backgroundContext: NSManagedObjectContext = {
//        let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
//        context.parent = mockPersistantContainer.viewContext
//        context.persistentStoreCoordinator = mockPersistantContainer.persistentStoreCoordinator
        return mockPersistantContainer.newBackgroundContext()
//        return context
    }()

    override func setUp() {
        testScheduler = TestScheduler(initialClock: 0)
        localRepository = CoreDataTTRepository(context: backgroundContext)
        dataManager = .init(localRepository: localRepository,
                            serverRepository: MockServerRepository(context: backgroundContext))
    }

    override func tearDown() {
        dataManager = nil
        testScheduler.stop()
        testScheduler = nil
    }
    
    func timetableWith(timestamp: String) -> Timetable {
        let timetable = Timetable(context: backgroundContext)
        timetable.updateTimestamp = timestamp
        return timetable
    }
    
    func test_loadTimetable() {
    
        let exp = expectation(description: "")
        exp.expectedFulfillmentCount = 1
        
        //0 + 1
        dataManager.loadTimetable(timetableDetails: TimetableDetails(groupId: 779, groupName: "БПИ16-01"))
 
        dataManager.timetableOutput.subscribe { (event) in
            switch event {
            case .next(let timetable):
                print("Got timetable: \(timetable)")
                exp.fulfill()
            case .error(let error):
                fatalError()
            case .completed:
                fatalError()
            }
        
        }

        wait(for: [exp], timeout: 5.0)
    }
    
}

class MockServerRepository : TimetableRepository {
    
    internal init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    let context: NSManagedObjectContext
    
    func getTimetable(timetableDetails: TimetableDetails) -> Single<Timetable> {
        Single.create { [weak self] (single) -> Disposable in
            guard let self = self else { fatalError() }
            ///server payload
            Thread.sleep(forTimeInterval: 0.5)
            let decoder = JSONDecoder()
            decoder.userInfo[CodingUserInfoKey.context!] = self.context
            let timetable = FileLoader.shared.getLocalSchedule(decoder: decoder)
            assert(timetable != nil)
            timetable!.updateTimestamp = "\(Date().timeIntervalSince1970)"
            single(.success(timetable!))
            return Disposables.create()
        }.subscribeOn(ConcurrentDispatchQueueScheduler.init(qos: .userInteractive))
    }
    
    func save(timetable: Timetable) -> Completable {
        fatalError("MockServerRepository doesn't support 'save' method")
    }
    
}
