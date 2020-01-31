//
//  StubTTRepository.swift
//  SibGUTimetable
//
//  Created by Александр Камышев on 27.01.2020.
//  Copyright © 2020 Alexandr. All rights reserved.
//

import Foundation
import RxSwift

class StubTTRepository : TTRepository {
    func getTimetable(groupId: Int, groupName: String) -> Single<Timetable> {
        return .never()
    }
    
    func saveTimetable(timetable: Timetable) -> Completable {
        return .never()
    }
}
