//
//  TimetableScheduleViewModel.swift
//  SibGUTimetable
//
//  Created by Alexandr on 11/07/2019.
//  Copyright © 2019 Alexandr. All rights reserved.
//

import Foundation
import os
import RxSwift
import RxCocoa

protocol ViewModel {
    associatedtype Input
    associatedtype Output
    
    func transform(input: Input) -> Output
}

class TimetableViewModel: ViewModel {
    private let disposeBag = DisposeBag()
    private let dataManager: TimetableDataManager
    
    init(dataManager: TimetableDataManager) {
        self.dataManager = dataManager
    }
    
    func transform(input: Input) -> Output {
        let timetable = input
            .timetableDetails
            .compactMap {
                if $0 == nil {
                    //TODO: show error
                    logger.error("THERE'S NO TIMETABLE")
                }
                return $0
            }
            .debug()
            .flatMap { [dataManager] in
                dataManager.loadTimetable(timetableDetails: $0)
            }
            .asDriver { (error) -> Driver<TimetableFetchResult> in
                return .empty()
            }
        return Output(timetable: timetable)
    }

    var countOfDays: Int {
        return 30 * 4
    }
    
    var startPageViewDate: Date {
        return Date()
    }
    
    func getDay(from timetable: Timetable, at date: Date) -> Day {
        let weekIndex = CalendarParser.shared.currentNumberOfWeek(date: date)
        let dayIndex = CalendarParser.shared.currentDayOfWeek(date: date)
        let day = (timetable.weeks![weekIndex] as! Week).days![dayIndex] as! Day
        return day
    }

    func getDayViewModel(timetable: Timetable, at date: Date) -> TimetableDayViewModel {
        return TimetableDayViewModel(day: getDay(from: timetable, at: date), date: date)
    }
    
}

extension TimetableViewModel {
    struct Input {
        let timetableDetails: Observable<TimetableDetails?>
    }
    
    struct Output {
        let timetable: Driver<TimetableFetchResult>
    }
}

