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

class FakeLocalTimetableRepository: TimetableRepository {

    override func getSchedule() -> Observable<Schedule> {
        return Observable.create { (observer) -> Disposable in
            if let localSchedule = FileLoader.shared.getLocalSchedule() {
                observer.onNext(localSchedule)
            } else {
                observer.onError(RxError.unknown)
            }
            return Disposables.create()
        }
    }
    
}
