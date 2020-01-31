//
// Created by Alexandr on 30/08/2019.
// Copyright (c) 2019 Alexandr. All rights reserved.
//

import Foundation
import RxSwift

protocol TTRepository {
    
    func getTimetable(groupId: Int, groupName: String) -> Single<Timetable>
    
    func saveTimetable(timetable: Timetable) -> Completable
 
}

