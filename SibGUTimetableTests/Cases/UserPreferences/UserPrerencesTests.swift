//
//  UserPrerencesTests.swift
//  SibGUTimetableTests
//
//  Created by Александр Камышев on 04.02.2020.
//  Copyright © 2020 Alexandr. All rights reserved.
//

import XCTest
@testable import SibGUTimetable
import RxTest
import RxSwift

class UserPrerencesTests: XCTestCase {

    let disposeBag = DisposeBag()
    var userPreferences: UserPreferences!
    
    override func setUp() {
        userPreferences = DefaultsUserPreferences()
        userPreferences.clearTimetableDetails()
    }

    override func tearDown() {
        userPreferences = nil
    }

    func test_saveTimetableGroupName() {
        let groupName = "BPI"
        let timestamp = "123456"
        let details = TimetableDetails(groupId: 740, groupName: groupName, timestamp: timestamp)
        
        userPreferences.saveTimetableDetails(groupId: 740, groupName: groupName, timestamp: timestamp)
        
        XCTAssertEqual(userPreferences.getTimetableDetails(), details)
    }
    
    func test_clearTimetableGroupName() {
        userPreferences.clearTimetableDetails()
        XCTAssertNil(userPreferences.getTimetableDetails())
    }
    
    func test_nil_timetableDetails_if_empty_value() throws {
        test_clearTimetableGroupName()
        let details = try userPreferences.timetableDetails.toBlocking().first()!
        XCTAssertNil(details)
    }
    
    func test_valid_timetableDetails() throws {
        test_clearTimetableGroupName()
        let timetableDetails = TimetableDetails(groupId: 0, groupName: "MPI")
        userPreferences.saveTimetableDetails(timetableDetails)
        let details = try userPreferences.timetableDetails.toBlocking().first()!
        XCTAssertEqual(timetableDetails, details)
    }
    
    func test_timetableDetails_observable_output()  throws {
        test_clearTimetableGroupName()
        let timetableDetails = TimetableDetails(groupId: 0, groupName: "MPI")
        let exp1 = expectation(description: "Get initial timetable and newest")
        exp1.expectedFulfillmentCount = 2
        var isInitialValue = true
        userPreferences.timetableDetails.subscribe(onNext: { (value) in
            if isInitialValue {
                XCTAssertNil(value)
                isInitialValue = false
            } else {
                XCTAssertEqual(value, timetableDetails)
            }
            exp1.fulfill()
        }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: disposeBag)
        
        
        let exp2 = expectation(description: "Get newest timetable")
        exp2.expectedFulfillmentCount = 1
        userPreferences.saveTimetableDetails(timetableDetails)
        userPreferences.timetableDetails.subscribe(onNext: { (value) in
            XCTAssertEqual(value, timetableDetails)
            exp2.fulfill()
        }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: disposeBag)
        
        wait(for: [exp1, exp2], timeout: 1.0)
    }

}

