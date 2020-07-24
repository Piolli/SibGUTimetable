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
    
    func getTimetable(timetableDetails: TimetableDetails) -> Single<Timetable> {
        return NativeAPIServer.sharedInstance.fetchTimetable(timetableDetails: timetableDetails, jsonDecoder: jsonDecoder)
    }
    
    func save(timetable: Timetable) -> Completable {
        fatalError("ServerRepository doesn't support a save method")
    }
    
}
