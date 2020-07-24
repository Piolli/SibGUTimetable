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
    
    func loadTimetable(timetableDetails: TimetableDetails) {
        
        localRepository
            .getTimetable(timetableDetails: timetableDetails)
            .subscribe { [weak self] (timetable) in
                self?.timetableOutput.accept(timetable)
            } onError: { [weak self] (error) in
                self?.errorOutput.accept(error)
            }.disposed(by: disposeBag)

        serverRepository
            .getTimetable(timetableDetails: timetableDetails)
            .subscribe { [weak self] (timetable) in
                self?.timetableOutput.accept(timetable)
                self?.localRepository.save(timetable: timetable)
            } onError: { [weak self] (error) in
                self?.errorOutput.accept(error)
            }.disposed(by: disposeBag)
        
    }
    
    func preloadTimetable(timetableDetails: TimetableDetails) -> Completable {
         return serverRepository
            .getTimetable(timetableDetails: timetableDetails)
            .map { [weak self] (timetable) -> Void in
                self?.localRepository.save(timetable: timetable).subscribe(onCompleted: { [weak self] in
                    self?.timetableOutput.accept(timetable)
                }, onError: { error in
                    self?.errorOutput.accept(RxError.unknown)
                })
        }.asCompletable()
    }
    
}
