//
//  TimetableViewModelTests.swift
//  SibGUTimetableTests
//
//  Created by Александр Камышев on 29.09.2020.
//  Copyright © 2020 Alexandr. All rights reserved.
//

import XCTest
@testable import SibGUTimetable
import RxSwift
import RxCocoa
import RxTest
import CoreData

class TimetableViewModelTests: XCTestCase {
    
    var dataManager: TimetableDataManager!
    var testScheduler: TestScheduler!
    var localRepository: TimetableRepository!
    var mockServerRepository: MockServerRepository!
    let disposeBag = DisposeBag()
    
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
        return mockPersistantContainer.newBackgroundContext()
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

    func test_valid_timetable_details_valid_timetable() throws {
        //TODO: create MockDataManager
        let vm = TimetableViewModel(dataManager: dataManager)
        let input: Observable<TimetableDetails?> = Observable.just(TimetableDetails(groupId: 0, groupName: "БПИ16-01"))
        let output = vm.transform(input: TimetableViewModel.Input(timetableDetails: input))
        let result = try output.timetable.toBlocking().toArray()
        
        XCTAssertEqual(result.count, 2)
        //Check first value
        XCTAssertNil(result[0].timetable)
        XCTAssertEqual(result[0].storage, .local)
        XCTAssertEqual(result[0].error as? TimetableDataManagerError, TimetableDataManagerError.emptyStore)
        //Check second value
        XCTAssertNotNil(result[1].timetable)
        XCTAssertEqual(result[1].storage, .remote)
        XCTAssertNil(result[1].error)
    }
}
