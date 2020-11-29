//
//  ServerRepository.swift
//  SibGUTimetable
//
//  Created by Александр Камышев on 29.01.2020.
//  Copyright © 2020 Alexandr. All rights reserved.
//

import Foundation
import RxSwift
import CoreData

class ServerRepository : TimetableRepository {
    
    let context: NSManagedObjectContext
    let jsonDecoder: JSONDecoder
    
    init(context: NSManagedObjectContext) {
        self.context = context
        jsonDecoder = JSONDecoder()
        jsonDecoder.userInfo[CodingUserInfoKey.context!] = context
    }
    
    func getTimetable(_ timetableDetails: TimetableDetails) -> Single<TimetableFetchResult> {
        return NativeAPIServer.sharedInstance
            .fetchTimetable(timetableDetails: timetableDetails, jsonDecoder: jsonDecoder)
            .map { (timetable) -> TimetableFetchResult in
                return TimetableFetchResult(timetable: timetable, storage: .remote)
            }
    }
    
    func save(timetable: Timetable) -> Completable {
        fatalError("ServerRepository doesn't support a save method")
    }
    
    func save(timetable: Timetable, completion: (Result<Void, Error>) -> Void) {
        fatalError("ServerRepository doesn't support a save method")
    }
    
}
