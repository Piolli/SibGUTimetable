//
// Created by Alexandr on 30/08/2019.
// Copyright (c) 2019 Alexandr. All rights reserved.
//

import Foundation
import RxSwift

class TimetableRepository : TimetableRepositoryProtocol {
    
    func getSchedule() -> Observable<Schedule> {
        return PublishSubject<Schedule>.create { (observer) -> Disposable in
            //TODO: make network request
            return Disposables.create()
        }.subscribeOn(ConcurrentDispatchQueueScheduler(qos: .userInitiated))
    }

}
