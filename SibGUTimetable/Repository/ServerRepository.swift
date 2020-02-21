//
//  ServerRepository.swift
//  SibGUTimetable
//
//  Created by Александр Камышев on 29.01.2020.
//  Copyright © 2020 Alexandr. All rights reserved.
//

import Foundation
import RxSwift

class ServerRepository : TimetableRepository {
    
    func getTimetable(timetableDetails: TimetableDetails) -> Single<Timetable> {
        return NativeAPIServer.sharedInstance.fetchTimetable(timetableDetails: timetableDetails)
    }
    
    func saveTimetable(timetable: Timetable) -> Completable {
        fatalError("ServerRepository doesn't support a save method")
    }
    
}
