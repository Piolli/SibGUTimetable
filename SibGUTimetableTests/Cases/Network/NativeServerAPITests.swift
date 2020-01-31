//
//  NativeServerAPITests.swift
//  SibGUTimetableTests
//
//  Created by Александр Камышев on 11.01.2020.
//  Copyright © 2020 Alexandr. All rights reserved.
//

import XCTest
@testable import SibGUTimetable



class NativeServerAPITests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testFindGroup_validData() {
//        let exp = expectation(description: "request completed")
//        
//        NativeAPIServer().findGroup(queryGroupName: "БПИ16").subscribe(onNext: { (pairs) in
//            print("PAIRS", pairs)
//        }, onError: { (error) in
//            print("ERRORS", error)
//        }, onCompleted: {
//            exp.fulfill()
//        }, onDisposed: nil)
//        
//        wait(for: [exp], timeout: 8.0)
    }
    
    func testFindGroup_validRequest() {
        let exp = expectation(description: "request was completed")
        
        NativeAPIServer.sharedInstance.findGroup(queryGroupName: "БПИ").subscribe(onSuccess: { (pairs) in
            exp.fulfill()
            dump(pairs)
        }) { (error) in }
        
        wait(for: [exp], timeout: 3.0)
    }
    
    func testFindGroup_NotFound() {
        let exp = expectation(description: "request was completed")
        
        NativeAPIServer.sharedInstance.findGroup(queryGroupName: "БПИxx").subscribe(onSuccess: { (pairs) in
        }) { (error) in
            if let error = error as? ServerError {
                XCTAssertEqual(error, ServerError.notFound)
            }
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 3.0)
    }
    
    func test_group_search_view_model() {
        let exp = expectation(description: "request was completed")
//        let exp1 = expectation(description: "ERROR")
        
//        GroupSearchViewModelController(api: NativeAPIServer()).searchGroup(query: "БПИ").subscribe(onSuccess: { (viewModel) in
//            print(viewModel.groupPairs)
//            exp.fulfill()
//        }) { (error) in
////            exp1.fulfill()
//        }
        
        wait(for: [exp], timeout: 5.0)
    }
    
    func test_fetch_timetable_valid() {
        let exp = expectation(description: "fetch timetable completed")
        
        NativeAPIServer.sharedInstance.fetchTimetable(groupId: 740, groupName: "БПИ16-01").subscribe(onSuccess: { (timetable) in
            XCTAssertEqual(timetable.weeks?.count, 2)
            XCTAssertEqual(timetable.group_name, "БПИ16-01")
            print(timetable.updateTimestampTime)
            exp.fulfill()
        }) { (error) in
            
        }
        
        wait(for: [exp], timeout: 5.0)
    }

}
