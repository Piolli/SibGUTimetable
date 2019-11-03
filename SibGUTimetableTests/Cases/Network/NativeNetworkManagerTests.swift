//
//  NativeNetworkManagerTests.swift
//  SibGUTimetableTests
//
//  Created by Alexandr on 22/09/2019.
//  Copyright © 2019 Alexandr. All rights reserved.
//

import XCTest
import RxSwift
@testable import SibGUTimetable

class NativeNetworkManagerTests: XCTestCase {

    var sut: NetworkManager!
    let disposeBag = DisposeBag()
    
    let validURL = "http://127.0.0.1:5000/rasp/2weeks/group/%D0%91%D0%9F%D0%9816-01"
    let invalidURL = ""
    
    override func setUp() {
        sut = NetworkManager()
    }

    override func tearDown() {
        sut = nil
    }
    
    func testInit_createsNetworkManager() {
        XCTAssertNotNil(sut)
    }
    
    func testLoadSchedule_validURL_loadSuccess() {
        let expect = expectation(description: "callback returns valid schedule object")
        let expectData = FileLoader.shared.getLocalSchedule()
        let mockSession = MockNetworkSession<Schedule>()
        mockSession.data = expectData
        sut.session = mockSession
        
        sut.loadSchedule(from: validURL) { (result) in
            switch result {
            case .success(let schedule):
                XCTAssertEqual(schedule, expectData)
                expect.fulfill()
            case .error(_):
                break
            }
        }
        
        wait(for: [expect], timeout: 1.0)
    }
    
    func testLoadSchedule_invalidURL_loadError() {
        let expect = expectation(description: "callback returns error")
        let expectData = FileLoader.shared.getLocalSchedule()
        let mockSession = MockNetworkSession<Schedule>()
        mockSession.data = expectData
        sut.session = mockSession
        
        sut.loadSchedule(from: invalidURL) { (result) in
            switch result {
            case .success(_):
                break
            case .error(let error):
                XCTAssertNotNil(error)
                expect.fulfill()
            }
        }
        
        wait(for: [expect], timeout: 1.0)
    }
    
    func testLoadSchedule_validURL_nilData_loadError() {
        let expect = expectation(description: "callback returns error")
        let mockSession = MockNetworkSession<Schedule>()
        mockSession.data = nil
        sut.session = mockSession
        
        sut.loadSchedule(from: validURL) { (result) in
            switch result {
            case .success(_):
                break
            case .error(let error):
                XCTAssertNotNil(error)
                expect.fulfill()
            }
        }
        
        wait(for: [expect], timeout: 1.0)
    }

}
