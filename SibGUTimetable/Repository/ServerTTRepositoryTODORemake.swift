//
//  ServerTTRepositoryTODORemake.swift
//  SibGUTimetable
//
//  Created by Александр Камышев on 23.01.2020.
//  Copyright © 2020 Alexandr. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class ServerTTRepositoryTODORemake: TimetableRepository {
    
    let loadedTimetable: Timetable
    
    init(timetable: Timetable) {
        self.loadedTimetable = timetable
    }
    
    func getTimetable(_ timetableDetails: TimetableDetails) -> Single<TimetableFetchResult> {
        return Single.just(TimetableFetchResult(timetable: loadedTimetable, storage: .remote, error: nil))
    }
    
    func save(timetable: Timetable) -> Completable {
        .never()
    }
    
}
