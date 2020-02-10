//
//  UserPrerencesTests.swift
//  SibGUTimetableTests
//
//  Created by Александр Камышев on 04.02.2020.
//  Copyright © 2020 Alexandr. All rights reserved.
//

import XCTest
@testable import SibGUTimetable

class UserPrerencesTests: XCTestCase {

    var userPreferences: UserPreferences!
    
    override func setUp() {
        userPreferences = UserPreferences.sharedInstance
    }

    override func tearDown() {
        userPreferences = nil
    }

    func test_saveTimetableGroupName() {
        let groupName = "BPI"
        let timestamp = "123456"
        let details = TimetableDetails(groupName: groupName, timestamp: timestamp)
        
        userPreferences.saveTimetableDetails(groupName: groupName, timestamp: timestamp)
        
        XCTAssertEqual(userPreferences.getTimetableDetails(), details)
    }
    
    func test_clearTimetableGroupName() {
        userPreferences.clearTimetableDetails()
        
        XCTAssertNil(userPreferences.getTimetableDetails())
    }

}
