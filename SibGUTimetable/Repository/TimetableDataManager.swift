//
//  TTDataManager.swift
//  SibGUTimetable
//
//  Created by Александр Камышев on 29.01.2020.
//  Copyright © 2020 Alexandr. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import CoreData

enum TimetableDataManagerError : Error, Equatable {
    case emptyStore
    case didNotUpdate
    case serverError(String)
    case unknown
}

struct TimetableFetchResult {
    let timetable: Timetable
    let storage: StorageType
    
    enum StorageType {
        case local, remote
    }
}

class TimetableDataManager {
    
    private let localRepository: TimetableRepository
    private let serverRepository: TimetableRepository
    
    private let disposeBag = DisposeBag()
    
    init(localRepository: TimetableRepository, serverRepository: TimetableRepository) {
        self.localRepository = localRepository
        self.serverRepository = serverRepository
    }
    
    //TODO: move to NSManagedObject
    func deleteAll() {
//        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Timetable")
//        let deleteReq = NSBatchDeleteRequest(fetchRequest: fetch)
//        let result = try? AppDelegate.backgroundContext.execute(deleteReq)
//        try? AppDelegate.backgroundContext.save()
    }
    
    let semaphore = DispatchSemaphore(value: 1)
    
    func loadTimetable(timetableDetails: TimetableDetails) -> Single<TimetableFetchResult> {
        
        localRepository.getTimetable(timetableDetails)
            .catchError { (error) in
                logger.error("Local storage returns error: \(error.localizedDescription)")
                return self.serverRepository.getTimetable(timetableDetails)
            }
    }
    
    func checkTimetableExisting(_ details: TimetableDetails) -> Single<Void> {
        return loadTimetable(timetableDetails: details).map { _ in Void() }
    }
    
}
