//
//  SibGUTimetableTests.swift
//  SibGUTimetableTests
//
//  Created by Alexandr on 14/06/2019.
//  Copyright © 2019 Alexandr. All rights reserved.
//

import XCTest
@testable import SibGUTimetable

class SibGUTimetableTests: XCTestCase {

    override func setUp() {
      
    }

    override func tearDown() {

    }

    func testMonthToDate() {
        let date1 = CalendarParser.CalendarMonth(name: "asd", index: 8, countDays: 10).toDate(withDay: 7) //2 : 1
        print(CalendarParser.shared.currentDayOfWeek(date: date1))
        print(CalendarParser.shared.currentNumberOfWeek(date: date1))
        
        let date2 = CalendarParser.CalendarMonth(name: "asd", index: 7, countDays: 10).toDate(withDay: 29) //0 : 0
        print(CalendarParser.shared.currentDayOfWeek(date: date2))
        print(CalendarParser.shared.currentNumberOfWeek(date: date2))
    }
    
    func testWeeks() {
        let parser = CalendarParser.shared
        
        let myDate =  getDateFromComponents(year: 2019, month: 8, day: 5) //1 : 0
        let myDate1 = getDateFromComponents(year: 2019, month: 8, day: 10)//1 : 5
        let myDate2 = getDateFromComponents(year: 2019, month: 8, day: 11)//1 : 6
        let myDate3 = getDateFromComponents(year: 2019, month: 8, day: 14)//0 : 2
        
        print(myDate.dayNumberOfWeek())
        print(myDate1.dayNumberOfWeek())
        print(myDate2.dayNumberOfWeek())
        print(myDate3.dayNumberOfWeek())
        
        parser.date = myDate
        print("WeekNumber: \(parser.currentNumberOfWeek) dayInWeek: \(parser.currentDayOfWeek)")
        
        parser.date = myDate1
        print("WeekNumber: \(parser.currentNumberOfWeek) dayInWeek: \(parser.currentDayOfWeek)")
        
        parser.date = myDate2
        print("WeekNumber: \(parser.currentNumberOfWeek) dayInWeek: \(parser.currentDayOfWeek)")
        
        parser.date = myDate3
        print("WeekNumber: \(parser.currentNumberOfWeek) dayInWeek: \(parser.currentDayOfWeek)")
        
        print(Calendar.current.component(.weekday, from: Date()), "EASY")
//        XCTAssertEqual(parser.currentDayOfWeek, 2)
//        XCTAssertEqual(parser.currentNumberOfWeek, 1)
    }
    
    func testJsonToLesson() {
        let json = """
{
"end_time": "9:40",
"name": "Informatic",
"office": "L303",
"start_time": "8:00",
"teacher": "Teacher",
"type": "Lab"
}
"""
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let data = json.data(using: .utf8)!
        
        let context = appDelegate.persistentContainer.newBackgroundContext()
        let decoder = JSONDecoder()
        let lesson = try! decoder.decode(Lesson.self, from: data)
    
        XCTAssertEqual(lesson.name, "Informatic")
        XCTAssertEqual(lesson.type, "Lab")
        
        dump(lesson)
        
    }
    
    func testJsonToSchedule() {
        let json = """

"""
        var data = json.data(using: .utf8)!
        let decoder = JSONDecoder()
        let schedule = try! decoder.decode(Schedule.self, from: data)
        
        print("\n------------------------------\n")
        print(schedule.group_name)
        print(schedule.weeks?.count ?? -99)
    }
    
    
    func getDateFromComponents(year: Int, month: Int, day: Int) -> Date {
        let calendar = Calendar(identifier: .iso8601)
    
        
        return calendar.date(from: DateComponents(calendar: calendar, year: year, month: month, day: day))!
    }

}

extension Date {
    func dayNumberOfWeek() -> Int? {
        return Calendar.current.dateComponents([.weekdayOrdinal], from: self).weekdayOrdinal
    }
}
