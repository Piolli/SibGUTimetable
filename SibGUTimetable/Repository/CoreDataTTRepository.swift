//
// Created by Alexandr on 30/08/2019.
// Copyright (c) 2019 Alexandr. All rights reserved.
//

import Foundation
import RxSwift

class CoreDataTTRepository : TTRepository {
    
    enum TTError: Error {
        case noTimetable
        case serverError
        case anotherError
    }
    
    func getSchedule() -> Single<Timetable> {
        return Single<Timetable>.create { (single) -> Disposable in
            
            single(.error(TTError.anotherError))
            return Disposables.create()
        }.subscribeOn(ConcurrentDispatchQueueScheduler(qos: .userInitiated))
    }

}
