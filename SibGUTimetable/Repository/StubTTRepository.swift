//
//  StubTTRepository.swift
//  SibGUTimetable
//
//  Created by Александр Камышев on 27.01.2020.
//  Copyright © 2020 Alexandr. All rights reserved.
//

import Foundation
import RxSwift

class StubTTRepository : TimetableRepository {
    func getTimetable(_ timetableDetails: TimetableDetails) -> Single<TimetableFetchResult> {
        return .never()
    }
    
    func save(timetable: Timetable) -> Completable {
        return .never()
    }
    
    func save(timetable: Timetable, completion: (Result<Void, Error>) -> Void) {
        
    }
}
