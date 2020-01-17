//
//  TimetableRepositoryTests.swift
//  SibGUTimetableTests
//
//  Created by Alexandr on 03.11.2019.
//  Copyright © 2019 Alexandr. All rights reserved.
//

import XCTest
import RxSwift

@testable import SibGUTimetable

class TimetableRepositoryTests: XCTestCase {

//    var sut: TimetableRepository!
//    let disposeBag = DisposeBag()
//    
//    override func setUp() {
//        sut = FakeLocalTimetableRepository()
//    }
//
//    override func tearDown() {
//        sut = nil
//    }
//
//    func testGetSchedule_fileExists_returnsValidSchedule() {
//        let localScheduleObservable = sut.getSchedule()
//        let expect = expectation(description: "onNext method was called")
//        
//        localScheduleObservable.subscribe(onNext: { (schedule) in
//            XCTAssertNotNil(schedule)
//            XCTAssertEqual(schedule.group_name, "БПИ16-01")
//            XCTAssertEqual(schedule.weeks!.count, 2)
//            XCTAssertEqual((schedule.weeks!.firstObject as! Week).days?.count, 7)
//            XCTAssertEqual((schedule.weeks!.lastObject as! Week).days?.count, 7)
//            expect.fulfill()
//        }).disposed(by: disposeBag)
//        
//        wait(for: [expect], timeout: 1.0)
//    }

}
