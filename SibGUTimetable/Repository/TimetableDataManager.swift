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
    let timetable: Timetable?
    let storage: StorageType
    let error: Error?
    
    enum StorageType {
        case local, remote
    }
}

class TimetableDataManager {
    
    private let localRepository: TimetableRepository
    private let serverRepository: TimetableRepository
    
//    public let timetableOutput: PublishRelay<TimetableFetchResult> = .init()
    
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
    
    func loadTimetable(timetableDetails: TimetableDetails) -> Observable<TimetableFetchResult> {
        return Observable
            .merge(localRepository.getTimetable(timetableDetails).asObservable(),
                   serverRepository.getTimetable(timetableDetails).asObservable())
            .distinctUntilChanged({ (t1, t2) -> Bool in
                t1.timetable?.updateTimestampTime == t2.timetable?.updateTimestampTime
            })
            .debug("loadTimetable()", trimOutput: false)
            .map { [weak self] (timetableFetchResult) -> TimetableFetchResult in
                if timetableFetchResult.storage == .remote && timetableFetchResult.error == nil {
                    guard let self = self, let timetable = timetableFetchResult.timetable else {
                        fatalError("self = nil in map operator")
                    }
                    self.localRepository.save(timetable: timetable).subscribe(onCompleted: {
                        logger.debug("CoreDataRepository successfully saved Timetable")
                    }, onError: { (error) in
                        logger.error("CoreDataRepository didn't save Timetable")
                    }).disposed(by: self.disposeBag)
                }
                return timetableFetchResult
            }
//        let observable = Observable.concat(
//            localRepository.getTimetable(timetableDetails: timetableDetails)
//                .map({ (timetable) -> TimetableFetchResult in
//                    TimetableFetchResult(timetable: timetable, storage: .local, error: nil)
//                })
//            .catchError({ (error) -> Observable<TimetableFetchResult> in
//                logger.error("Local Repository getTimetable: \(error.localizedDescription)")
////                self.errorOutput.accept(error)
//                return .just(TimetableFetchResult(timetable: nil, storage: .local, error: NSError(domain: "Local storage doesn't load timetable", code: 100, userInfo: nil)))
//            }),
//            serverRepository
//                .getTimetable(timetableDetails: timetableDetails)
//                .map({ [weak self] (timetable) -> TimetableFetchResult in
//                    guard let self = self else {
//                        fatalError("self is nil in getTimetable")
//                    }
//                    logger.info("LocalRepository is saving timetable")
//                    self.localRepository.save(timetable: timetable).subscribe (onCompleted: {
//                        logger.info("Timetable was saved to LocalRepository")
//                    }, onError: { [weak self] (error) in
//                        logger.info("Timetable error while saving to LocalRepository: \(error)")
//                    }).disposed(by: self.disposeBag)
//                    return TimetableFetchResult(timetable: timetable, storage: .remote, error: nil)
//                })
//                .asObservable()
//                .catchError({ [weak self] (error) -> Observable<TimetableFetchResult> in
//                    let nserror = NSError(domain: LocalizedStrings.Error_occured_while_loading_timetable, code: 101, userInfo: nil)
//                    return TimetableFetchResult(timetable: nil, storage: .remote, error: nserror)
//                })
//            ///Observer catch any errors from this observable
//
//        )
//        .subscribeOn(ConcurrentDispatchQueueScheduler.init(qos: .background))
        
        
        
//        observable.bind(to: timetableOutput).disposed(by: disposeBag)
        
//        observable.subscribe (onNext: { [weak self] (timetable) in
//            self?.semaphore.wait()
//            self?.timetableOutput.accept(timetable)
//            self?.semaphore.signal()
//        }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: disposeBag)
    
    }
    
}
