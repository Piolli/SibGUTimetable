//
// Created by Alexandr on 30/08/2019.
// Copyright (c) 2019 Alexandr. All rights reserved.
//

import Foundation
import RxSwift

protocol TimetableRepository {
    
    func getTimetable(timetableDetails: TimetableDetails) -> Single<Timetable>
    
    func save(timetable: Timetable) -> Completable
 
}

