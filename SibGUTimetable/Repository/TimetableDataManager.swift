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

enum TimetableDataManagerError : Error {
    case emptyStore
    case didNotUpdate
    case serverError(String)
    case unknown
}

class TimetableDataManager {
    
    private let localRepository: TimetableRepository
    private let serverRepository: TimetableRepository
    
    public let timetable: PublishRelay<Timetable> = .init()
    public let error: PublishRelay<TimetableDataManagerError> = .init()
    
    init(localRepository: TimetableRepository, serverRepository: TimetableRepository) {
        self.localRepository = localRepository
        self.serverRepository = serverRepository
    }
    
    func deleteAll() {
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Timetable")
        let deleteReq = NSBatchDeleteRequest(fetchRequest: fetch)
        let result = try? AppDelegate.backgroundContext.execute(deleteReq)
        try? AppDelegate.backgroundContext.save()
    }
    
    func loadTimetable(timetableDetails: TimetableDetails) -> Observable<Timetable> {
        let observable = localRepository
        .getTimetable(timetableDetails: timetableDetails)
        .asObservable()
        .catchError { [weak self] (error) -> Observable<Timetable> in
            guard let self = self else {
                return Observable.error(RxError.unknown)
            }
            logger.trace("RXSWIFTLOG: load timetable from server")
            return
                self.serverRepository.getTimetable(timetableDetails: timetableDetails)
                    .map {
                        self.localRepository.saveTimetable(timetable: $0).debug("saveTimetable", trimOutput: false).debug("Save server", trimOutput: false).subscribe(onCompleted: {
                        }) { [weak self] (error) in
                            self?.error.accept(TimetableDataManagerError.serverError(error.localizedDescription))
                            logger.error("\(error.localizedDescription)")
                        }
                        
                        return $0
                    }.asObservable().debug("CatchError", trimOutput: false)
        }
        .debug("RXSWIFT", trimOutput: false)
        
        
        
        observable.subscribe(onNext: { [weak self] (timetable) in
            self?.timetable.accept(timetable)
        }, onError: { (error) in
            
        }, onCompleted: nil, onDisposed: nil)
        
        return observable
    }
    
    func preloadTimetable(timetableDetails: TimetableDetails) -> Completable {
         return serverRepository
            .getTimetable(timetableDetails: timetableDetails)
            .map { [weak self] (timetable) -> Void in
                self?.localRepository.saveTimetable(timetable: timetable).subscribe(onCompleted: { [weak self] in
                    self?.timetable.accept(timetable)
                }, onError: { error in
                    self?.error.accept(.didNotUpdate)
                })
        }.asCompletable()
    }
    
}
