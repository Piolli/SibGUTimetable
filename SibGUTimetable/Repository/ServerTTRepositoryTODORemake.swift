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

class ServerTTRepositoryTODORemake: TTRepository {
    
    let loadedTimetable: Timetable
    
    init(timetable: Timetable) {
        self.loadedTimetable = timetable
    }
    
    func getTimetable(groupId: Int, groupName: String) -> Single<Timetable> {
        return Single.just(loadedTimetable)
    }
    
    func saveTimetable(timetable: Timetable) -> Completable {
        .never()
    }
    
}
