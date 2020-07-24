//
//  FakeLocalTimetableRepository.swift
//  SibGUTimetable
//
//  Created by Alexandr on 02.11.2019.
//  Copyright © 2019 Alexandr. All rights reserved.
//

import Foundation

import RxSwift
import RxCocoa

class FakeLocalTTRepository: TimetableRepository {
    
    let timetable: Timetable
    
    init(timetable: Timetable) {
        self.timetable = timetable
    }
    
    func getTimetable(timetableDetails: TimetableDetails) -> Single<Timetable> {
        return Single.create { (single) -> Disposable in
            single(.success(self.timetable))
            return Disposables.create()
        }.debug("FakeLocalTTRepository (get)", trimOutput: false)
    }
    
    func save(timetable: Timetable) -> Completable {
        logger.debug("It saved nothing")
        return .never()
    }
    
}
