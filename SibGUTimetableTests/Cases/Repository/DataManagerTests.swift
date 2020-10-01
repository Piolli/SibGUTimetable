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
    var mockServerRepository: MockServerRepository!
    
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
        localRepository = CoreDataTimetableRepository(context: backgroundContext)
        mockServerRepository = MockServerRepository(context: backgroundContext, produceUniqieTimespamp: true)
        dataManager = .init(localRepository: localRepository,
                            serverRepository: mockServerRepository)
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
    
    func test_loadTimetable() throws {
        let ts1 = try dataManager.loadTimetable(timetableDetails: TimetableDetails(groupId: 0, groupName: "БПИ16-01")).toBlocking().toArray()
        XCTAssertEqual(ts1.count, 2)
        print("-----------------------\nOUTPUT:")
        dump(ts1)
        //Local storage doesn't constain any timetable
        XCTAssertNil(ts1.first(where: {$0.storage == .local})?.timetable)
        //Local storage loaded timetable successfully
        XCTAssertNotNil(ts1.first(where: {$0.storage == .remote})?.timetable)
        
        mockServerRepository.produceUniqieTimespamp = true
        let ts2 = try dataManager.loadTimetable(timetableDetails: TimetableDetails(groupId: 0, groupName: "БПИ16-01")).toBlocking().toArray()
        //Returns local and remote (because unique timestamp)
        XCTAssertEqual(ts2.count, 2)
        //Local storage doesn't contain any timetable
        XCTAssertNotNil(ts2.first(where: {$0.storage == .local})?.timetable)
        //Remote storage loaded timetable successfully
        XCTAssertNotNil(ts2.first(where: {$0.storage == .remote})?.timetable)
        
        
        mockServerRepository.produceUniqieTimespamp = false
        let ts3 = try dataManager.loadTimetable(timetableDetails: TimetableDetails(groupId: 0, groupName: "БПИ16-01")).toBlocking().toArray()
        //Returns only local (because non-unique timestamp and `distinctUntilChanges` did work)
        XCTAssertEqual(ts3.count, 1)
        //Local storage contains timetable
        XCTAssertNotNil(ts3.first(where: {$0.storage == .local})?.timetable)
        //Remote storage didn't emit any value because `distinctUntilChanges`
        XCTAssertNil(ts3.first(where: {$0.storage == .remote})?.timetable)
        
        print("-----------------------\nOUTPUT:")
        dump(ts3)
    }
    
}

class MockServerRepository : TimetableRepository {
    
    internal init(context: NSManagedObjectContext, produceUniqieTimespamp: Bool) {
        self.context = context
        self.produceUniqieTimespamp = produceUniqieTimespamp
    }
    
    //If false produce previous value
    var produceUniqieTimespamp: Bool
    private var previousTimestampValue: String!
    
    let context: NSManagedObjectContext
    
    func getTimetable(_ timetableDetails: TimetableDetails) -> Single<TimetableFetchResult> {
        Single.create { [weak self] (single) -> Disposable in
            guard let self = self else { fatalError() }
            ///server payload
            Thread.sleep(forTimeInterval: 0.0)
            let decoder = JSONDecoder()
            decoder.userInfo[CodingUserInfoKey.context!] = self.context
            let timetable = FileLoader.shared.getLocalSchedule(decoder: decoder)
            assert(timetable != nil)
            timetable!.updateTimestamp = self.produceUniqieTimespamp ? "\(Date().timeIntervalSince1970)" : self.previousTimestampValue
            self.previousTimestampValue = timetable!.updateTimestamp!
            single(.success(TimetableFetchResult(timetable: timetable!, storage: .remote, error: nil)))
            return Disposables.create()
        }
//        .subscribeOn(ConcurrentDispatchQueueScheduler.init(qos: .userInteractive))
    }
    
    func save(timetable: Timetable) -> Completable {
        fatalError("MockServerRepository doesn't support 'save' method")
    }
    
}
