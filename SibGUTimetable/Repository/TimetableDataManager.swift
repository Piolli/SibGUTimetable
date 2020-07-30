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
    
    public let timetableOutput: PublishRelay<Timetable> = .init()
    public let errorOutput: PublishRelay<Error> = .init()
    
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
    
    func loadTimetable(timetableDetails: TimetableDetails) {
        
        let observable = Observable.concat(
            localRepository.getTimetable(timetableDetails: timetableDetails)
            .asObservable()
            .catchError({ (error) -> Observable<Timetable> in
                logger.error("Local Repository getTimetable: \(error.localizedDescription)")
                self.errorOutput.accept(error)
                return .empty()
            }),
            ///Observer catch any errors from this observable
            serverRepository.getTimetable(timetableDetails: timetableDetails).map({ [weak self] (timetable) -> Timetable in
                guard let self = self else {
                    fatalError("self is nil in getTimetable")
                }
                logger.info("LocalRepository is saving timetable")
                self.localRepository.save(timetable: timetable).subscribe (onCompleted: {
                    logger.info("Timetable was saved to LocalRepository")
                }, onError: { [weak self] (error) in
                    logger.info("Timetable error while saving to LocalRepository: \(error)")
                    self?.errorOutput.accept(error)
                }).disposed(by: self.disposeBag)

                return timetable
            }).asObservable()
        )
        .subscribeOn(ConcurrentDispatchQueueScheduler.init(qos: .background))
        
        observable
            .subscribe (onNext: { [weak self] (timetable) in
            self?.timetableOutput.accept(timetable)
        }, onError: { [weak self] (error) in
            logger.error("Error: \(error.localizedDescription)")
            self?.errorOutput.accept(error)

        }, onCompleted: { [weak self] in

        }, onDisposed: {
            
        }).disposed(by: disposeBag)
    
    }
    
}
