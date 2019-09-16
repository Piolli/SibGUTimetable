//
// Created by Alexandr on 30/08/2019.
// Copyright (c) 2019 Alexandr. All rights reserved.
//

import Foundation
import RxSwift

let json =
"""
{"group_name": "БПИ16-01", "weeks": [{"days": [{"lessons": [{"name": "ЭКОНОМИКА", "type": "Лекция", "office": "корп. Л каб. 319", "teacher": "3479", "start_time": "09:40", "end_time": "11:10"}, {"name": "КОНСТРУИРОВАНИЕ ПРОГРАММНОГО ОБЕСПЕЧЕНИЯ", "type": "Лекция", "office": "корп. Л каб. 318", "teacher": "1397", "start_time": "11:30", "end_time": "13:00"}, {"name": "КОНСТРУИРОВАНИЕ ПРОГРАММНОГО ОБЕСПЕЧЕНИЯ", "type": "Лабораторная работа", "office": "корп. Л каб. 318", "teacher": "1397", "start_time": "13:30", "end_time": "15:00"}, {"name": "КОНСТРУИРОВАНИЕ ПРОГРАММНОГО ОБЕСПЕЧЕНИЯ", "type": "Лабораторная работа", "office": "корп. Л каб. 318", "teacher": "1397", "start_time": "15:10", "end_time": "16:40"}], "header": "Понедельник", "order": 0}, {"lessons": [{"name": "НАДЕЖНОСТЬ ИНФОРМАЦИОННЫХ СИСТЕМ", "type": "Лабораторная работа", "office": "корп. Л каб. 303", "teacher": "615", "start_time": "11:30", "end_time": "13:00"}, {"name": "НАДЕЖНОСТЬ ИНФОРМАЦИОННЫХ СИСТЕМ", "type": "Лекция", "office": "корп. Л каб. 301", "teacher": "615", "start_time": "13:30", "end_time": "15:00"}, {"name": "ПРОБЛЕМНО-ОРИЕНТИРОВАННЫЕ МУЛЬТИЛИНГВИСТИЧЕСКИЕ ТЕХНОЛОГИИ", "type": "Практика", "office": "корп. Л каб. 306", "teacher": "1576", "start_time": "15:10", "end_time": "16:40"}, {"name": "ПРОБЛЕМНО-ОРИЕНТИРОВАННЫЕ МУЛЬТИЛИНГВИСТИЧЕСКИЕ ТЕХНОЛОГИИ", "type": "Практика", "office": "корп. Л каб. 306", "teacher": "1576", "start_time": "16:50", "end_time": "18:20"}], "header": "Вторник", "order": 1}, {"lessons": [{"name": "МАТЕМАТИЧЕСКИЕ ОСНОВЫ ИСКУССТВЕННОГО ИНТЕЛЛЕКТА", "type": "Лабораторная работа", "office": "корп. Л каб. 303", "teacher": "536", "start_time": "13:30", "end_time": "15:00"}, {"name": "ОСНОВЫ ИНЖЕНЕРНОЙ ПСИХОЛОГИИ", "type": "Практика", "office": "корп. Л каб. 316", "teacher": "3655", "start_time": "15:10", "end_time": "16:40"}, {"name": "ОСНОВЫ ИНЖЕНЕРНОЙ ПСИХОЛОГИИ", "type": "Практика", "office": "корп. Л каб. 316", "teacher": "3655", "start_time": "16:50", "end_time": "18:20"}], "header": "Среда", "order": 2}, {"lessons": [], "header": "Четверг", "order": 3}, {"lessons": [{"name": "ЭКОНОМИКА", "type": "Практика", "office": "корп. Н каб. 106", "teacher": "3479", "start_time": "11:30", "end_time": "13:00"}, {"name": "УПРАВЛЕНИЕ ПРОГРАММНЫМИ ПРОЕКТАМИ", "type": "Лабораторная работа", "office": "корп. Л каб. 315", "teacher": "3354", "start_time": "13:30", "end_time": "15:00"}, {"name": "УПРАВЛЕНИЕ ПРОГРАММНЫМИ ПРОЕКТАМИ", "type": "Лабораторная работа", "office": "корп. Л каб. 315", "teacher": "3354", "start_time": "15:10", "end_time": "16:40"}, {"name": "ЗАЩИТА ИНФОРМАЦИИ", "type": "Лабораторная работа", "office": "корп. Е каб. 37", "teacher": "2026", "start_time": "16:50", "end_time": "18:20"}], "header": "Пятница", "order": 4}, {"lessons": [], "header": "Суббота", "order": 5}, {"lessons": [], "header": "Воскресенье", "order": 6}], "number_week": 0}, {"days": [{"lessons": [{"name": "ЭКОНОМИКА", "type": "Лекция", "office": "корп. Л каб. 319", "teacher": "3479", "start_time": "09:40", "end_time": "11:10"}, {"name": "ЭКОНОМИКА", "type": "Практика", "office": "корп. Л каб. 316", "teacher": "3479", "start_time": "11:30", "end_time": "13:00"}, {"name": "МАТЕМАТИЧЕСКИЕ ОСНОВЫ ИСКУССТВЕННОГО ИНТЕЛЛЕКТА", "type": "Лекция", "office": "корп. Л каб. 301", "teacher": "536", "start_time": "13:30", "end_time": "15:00"}, {"name": "МАТЕМАТИЧЕСКИЕ ОСНОВЫ ИСКУССТВЕННОГО ИНТЕЛЛЕКТА", "type": "Лабораторная работа", "office": "корп. Л каб. 315", "teacher": "536", "start_time": "15:10", "end_time": "16:40"}], "header": "Понедельник", "order": 0}, {"lessons": [], "header": "Вторник", "order": 1}, {"lessons": [{"name": "УПРАВЛЕНИЕ ПРОГРАММНЫМИ ПРОЕКТАМИ", "type": "Лекция", "office": "корп. Л каб. 301", "teacher": "3354", "start_time": "15:10", "end_time": "16:40"}, {"name": "НАДЕЖНОСТЬ ИНФОРМАЦИОННЫХ СИСТЕМ", "type": "Лабораторная работа", "office": "корп. Л каб. 303", "teacher": "615", "start_time": "16:50", "end_time": "18:20"}], "header": "Среда", "order": 2}, {"lessons": [], "header": "Четверг", "order": 3}, {"lessons": [{"name": "ТЕОРИЯ ПРИНЯТИЯ РЕШЕНИЙ", "type": "Лекция", "office": "корп. Н каб. 211", "teacher": "3461", "start_time": "13:30", "end_time": "15:00"}, {"name": "ТЕОРИЯ ПРИНЯТИЯ РЕШЕНИЙ", "type": "Лабораторная работа", "office": "корп. Н каб. 204", "teacher": "3461", "start_time": "15:10", "end_time": "16:40"}, {"name": "ТЕОРИЯ ПРИНЯТИЯ РЕШЕНИЙ", "type": "Лабораторная работа", "office": "корп. Н каб. 204", "teacher": "3461", "start_time": "16:50", "end_time": "18:20"}], "header": "Пятница", "order": 4}, {"lessons": [{"name": "ЗАЩИТА ИНФОРМАЦИИ", "type": "Лекция", "office": "корп. Е каб. 33", "teacher": "2026", "start_time": "09:40", "end_time": "11:10"}, {"name": "ЗАЩИТА ИНФОРМАЦИИ", "type": "Лабораторная работа", "office": "корп. Е каб. 32", "teacher": "2026", "start_time": "11:30", "end_time": "13:00"}, {"name": "ЗАЩИТА ИНФОРМАЦИИ", "type": "Лабораторная работа", "office": "корп. Е каб. 32", "teacher": "2026", "start_time": "13:30", "end_time": "15:00"}], "header": "Суббота", "order": 5}, {"lessons": [], "header": "Воскресенье", "order": 6}], "number_week": 1}]}
"""

class TimetableRepository : TimetableRepositoryProtocol {
    
    func getSchedule() -> Observable<Schedule> {
        return PublishSubject<Schedule>.create { (observer) -> Disposable in
            let data = json.data(using: .utf8)
            let decoder = JSONDecoder()
            if let data = data {
                DispatchQueue.main.async {
                    if let schedule = try? decoder.decode(Schedule.self, from: data) {
                        Logger.logMessageInfo(message: "success get schedule in async")
                        observer.onNext(schedule)
                    }
                }
            }
            return Disposables.create()
        }.subscribeOn(ConcurrentDispatchQueueScheduler(qos: .userInitiated))
    }

}
