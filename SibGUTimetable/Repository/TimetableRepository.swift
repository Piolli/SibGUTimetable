//
// Created by Alexandr on 30/08/2019.
// Copyright (c) 2019 Alexandr. All rights reserved.
//

import Foundation
import RxSwift

protocol TimetableRepository {
    
    func getTimetable(_ timetableDetails: TimetableDetails) -> Single<TimetableFetchResult>
    
    func save(timetable: Timetable) -> Completable
    
    func save(timetable: Timetable, completion: (Result<Void, Error>) -> Void)
 
}

