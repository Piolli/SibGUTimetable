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

class FakeLocalTTRepository: TTRepository {
    func getTimetable(groupId: Int, groupName: String) -> Single<Timetable> {
        return Single.create { (single) -> Disposable in
            if let localSchedule = FileLoader.shared.getLocalSchedule() {
                single(.success(localSchedule))
            } else {
                single(.error(RxError.unknown))
            }
            return Disposables.create()
        }.debug("FakeLocalTTRepository (get)", trimOutput: false)
    }
    
    func saveTimetable(timetable: Timetable) -> Completable {
        .never()
    }
    
}
