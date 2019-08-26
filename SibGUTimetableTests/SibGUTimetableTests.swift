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
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
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
{"group_name": "БПИ16-01", "weeks": [{"days": [{"lessons": [{"name": "* подгруппаПРОФЕССИОНАЛЬНО-ПРИКЛАДНАЯ ФИЗИЧЕСКАЯ КУЛЬТУРА", "type": "Практика", "office": "корп. ДВС каб. 0", "teacher": "2187", "start_time": "09:40", "end_time": "11:10"}, {"name": "ЭКОНОМИКА И УПРАВЛЕНИЕ МАШИНОСТРОИТЕЛЬНЫМ ПРОИЗВОДСТВОМ", "type": "Практика", "office": "корп. Н каб. 506", "teacher": "132", "start_time": "11:30", "end_time": "13:00"}, {"name": "ЭКОНОМИКА И УПРАВЛЕНИЕ МАШИНОСТРОИТЕЛЬНЫМ ПРОИЗВОДСТВОМ", "type": "Лекция", "office": "корп. Н каб. 506", "teacher": "132", "start_time": "13:30", "end_time": "15:00"}], "header": "Понедельник", "order": 1}, {"lessons": [{"name": "ИНФРАСТРУКТУРА НОВОВВЕДЕНИЙ", "type": "Лекция", "office": "корп. Н каб. 506", "teacher": "132", "start_time": "13:30", "end_time": "15:00"}, {"name": "МЕНЕДЖМЕНТ В ИННОВАЦИОННОЙ СФЕРЕ", "type": "Лекция", "office": "корп. Н каб. 501", "teacher": "2209", "start_time": "15:10", "end_time": "16:40"}, {"name": "МЕНЕДЖМЕНТ В ИННОВАЦИОННОЙ СФЕРЕ", "type": "Практика", "office": "корп. Н каб. 501", "teacher": "2209", "start_time": "16:50", "end_time": "18:20"}], "header": "Вторник", "order": 1}, {"lessons": [{"name": "ОРГАНИЗАЦИЯ И ПЛАНИРОВАНИЕ ПРОИЗВОДСТВА", "type": "Практика", "office": "корп. Н каб. 501", "teacher": "3371", "start_time": "09:40", "end_time": "11:10"}, {"name": "ОРГАНИЗАЦИЯ И ПЛАНИРОВАНИЕ ПРОИЗВОДСТВА", "type": "Лекция", "office": "корп. Н каб. 501", "teacher": "1374", "start_time": "11:30", "end_time": "13:00"}, {"name": "СИСТЕМНЫЙ АНАЛИЗ И ПРИНЯТИЕ РЕШЕНИЙ", "type": "Лекция", "office": "корп. Л каб. 313", "teacher": "1477", "start_time": "13:30", "end_time": "15:00"}, {"name": "СИСТЕМНЫЙ АНАЛИЗ И ПРИНЯТИЕ РЕШЕНИЙ", "type": "Практика", "office": "корп. Л каб. 313", "teacher": "1477", "start_time": "15:10", "end_time": "16:40"}], "header": "Среда", "order": 1}, {"lessons": [{"name": "* подгруппаПРОФЕССИОНАЛЬНО-ПРИКЛАДНАЯ ФИЗИЧЕСКАЯ КУЛЬТУРА", "type": "Практика", "office": "корп. ДВС каб. 0", "teacher": "1457", "start_time": "09:40", "end_time": "11:10"}, {"name": "ИНФРАСТРУКТУРА НОВОВВЕДЕНИЙ", "type": "Практика", "office": "корп. Н каб. 506", "teacher": "132", "start_time": "11:30", "end_time": "13:00"}, {"name": "ИНФРАСТРУКТУРА НОВОВВЕДЕНИЙ", "type": "Практика", "office": "корп. Н каб. 506", "teacher": "132", "start_time": "13:30", "end_time": "15:00"}, {"name": "ФИЛОСОФИЯ", "type": "Лекция", "office": "корп. Н каб. 501", "teacher": "2170", "start_time": "15:10", "end_time": "16:40"}], "header": "Четверг", "order": 1}, {"lessons": [], "header": "", "order": 1}, {"lessons": [], "header": "", "order": 1}, {"lessons": [], "header": "", "order": 1}], "number_week": 1}, {"days": [{"lessons": [{"name": "* подгруппаПРОФЕССИОНАЛЬНО-ПРИКЛАДНАЯ ФИЗИЧЕСКАЯ КУЛЬТУРА", "type": "Практика", "office": "корп. ДВС каб. 0", "teacher": "2187", "start_time": "09:40", "end_time": "11:10"}, {"name": "РУССКИЙ ЯЗЫК ДЕЛОВОГО ОБЩЕНИЯ", "type": "Практика", "office": "корп. Л каб. 411", "teacher": "2526", "start_time": "11:30", "end_time": "13:00"}, {"name": "РУССКИЙ ЯЗЫК ДЕЛОВОГО ОБЩЕНИЯ", "type": "Практика", "office": "корп. Л каб. 411", "teacher": "2526", "start_time": "13:30", "end_time": "15:00"}, {"name": "СИСТЕМНЫЙ АНАЛИЗ И ПРИНЯТИЕ РЕШЕНИЙ", "type": "Практика", "office": "корп. Л каб. 313", "teacher": "1477", "start_time": "15:10", "end_time": "16:40"}], "header": "Понедельник", "order": 1}, {"lessons": [{"name": "ОРГАНИЗАЦИЯ И УПРАВЛЕНИЕ ИНТЕЛЛЕКТУАЛЬНОЙ СОБСТВЕННОСТЬЮ", "type": "Лекция", "office": "корп. Н каб. 604", "teacher": "764", "start_time": "09:40", "end_time": "11:10"}, {"name": "ОРГАНИЗАЦИЯ И УПРАВЛЕНИЕ ИНТЕЛЛЕКТУАЛЬНОЙ СОБСТВЕННОСТЬЮ", "type": "Практика", "office": "корп. Н каб. 604", "teacher": "764", "start_time": "11:30", "end_time": "13:00"}, {"name": "НАУЧНЫЙ СЕМИНАР", "type": "Практика", "office": "корп. Н каб. 501", "teacher": "3141", "start_time": "13:30", "end_time": "15:00"}, {"name": "НАУЧНЫЙ СЕМИНАР", "type": "Практика", "office": "корп. Н каб. 501", "teacher": "3141", "start_time": "15:10", "end_time": "16:40"}], "header": "Вторник", "order": 1}, {"lessons": [{"name": "ИНОСТРАННЫЙ ЯЗЫК", "type": "Практика", "office": "корп. Л каб. 614", "teacher": "5316", "start_time": "08:00", "end_time": "09:30"}, {"name": "ИНОСТРАННЫЙ ЯЗЫК", "type": "Практика", "office": "корп. Л каб. 614", "teacher": "5316", "start_time": "09:40", "end_time": "11:10"}, {"name": "ИНОСТРАННЫЙ ЯЗЫК", "type": "Практика", "office": "корп. Л каб. 614", "teacher": "2773", "start_time": "11:30", "end_time": "13:00"}, {"name": "ИНОСТРАННЫЙ ЯЗЫК", "type": "Практика", "office": "корп. Л каб. 614", "teacher": "2773", "start_time": "13:30", "end_time": "15:00"}], "header": "Среда", "order": 1}, {"lessons": [{"name": "* подгруппаПРОФЕССИОНАЛЬНО-ПРИКЛАДНАЯ ФИЗИЧЕСКАЯ КУЛЬТУРА", "type": "Практика", "office": "корп. ДВС каб. 0", "teacher": "763", "start_time": "09:40", "end_time": "11:10"}, {"name": "ЭКОНОМИКА И УПРАВЛЕНИЕ МАШИНОСТРОИТЕЛЬНЫМ ПРОИЗВОДСТВОМ", "type": "Практика", "office": "корп. Н каб. 506", "teacher": "132", "start_time": "11:30", "end_time": "13:00"}, {"name": "ИНОСТРАННЫЙ ЯЗЫК", "type": "Практика", "office": "корп. Н каб. 611", "teacher": "5316", "start_time": "13:30", "end_time": "15:00"}, {"name": "ИНОСТРАННЫЙ ЯЗЫК", "type": "Практика", "office": "корп. Н каб. 611", "teacher": "5316", "start_time": "15:10", "end_time": "16:40"}], "header": "Четверг", "order": 1}, {"lessons": [{"name": "ФИЛОСОФИЯ", "type": "Лекция", "office": "корп. Л каб. 604", "teacher": "2170", "start_time": "09:40", "end_time": "11:10"}, {"name": "ФИЛОСОФИЯ", "type": "Практика", "office": "корп. Л каб. 604", "teacher": "2170", "start_time": "11:30", "end_time": "13:00"}], "header": "Пятница", "order": 1}, {"lessons": [], "header": "", "order": 1}, {"lessons": [], "header": "", "order": 1}], "number_week": 2}]}
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
