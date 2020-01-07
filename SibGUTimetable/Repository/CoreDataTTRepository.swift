//
// Created by Alexandr on 30/08/2019.
// Copyright (c) 2019 Alexandr. All rights reserved.
//

import Foundation
import RxSwift

class CoreDataTTRepository : TTRepository {
    
    func getSchedule() -> Observable<Timetable> {
        return PublishSubject<Timetable>.create { (observer) -> Disposable in
            //TODO: make network request
            return Disposables.create()
        }.subscribeOn(ConcurrentDispatchQueueScheduler(qos: .userInitiated))
    }

}
