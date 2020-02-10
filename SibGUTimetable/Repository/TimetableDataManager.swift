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
    
    convenience init() {
//        //TODO: DI with assembler
////        self.init(localTTRepository: , serverTTRepository: )
        fatalError("DI with assembler")
    }
    
    func deleteAll() {
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Timetable")
        let deleteReq = NSBatchDeleteRequest(fetchRequest: fetch)
        let result = try? AppDelegate.backgroundContext.execute(deleteReq)
        print("---------", result.debugDescription)
        try? AppDelegate.backgroundContext.save()
    }
    
    func loadTimetable(groupId: Int, groupName: String) -> Observable<Timetable> {
        let observable = localRepository
        .getTimetable(groupId: groupId, groupName: groupName)
        .asObservable()
        .catchError { [weak self] (error) -> Observable<Timetable> in
            guard let self = self else {
                return Observable.error(RxError.unknown)
            }
            print("RXSWIFTLOG: load timetable from server")
            return
                self.serverRepository.getTimetable(groupId: groupId, groupName: groupName)
                    .map {
                        self.localRepository.saveTimetable(timetable: $0).debug("saveTimetable", trimOutput: false).debug("Save server", trimOutput: false).subscribe(onCompleted: {
                        }) { [weak self] (error) in
                            self?.error.accept(TimetableDataManagerError.serverError(error.localizedDescription))
                            print("ERROR:", error.localizedDescription)
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
    
    func updateTimetable(groupId: Int, groupName: String) -> Observable<Timetable> {
        let observable = serverRepository
            .getTimetable(groupId: groupId, groupName: groupName)
            .map { [weak self] (timetable) -> Timetable in
                self?.localRepository.saveTimetable(timetable: timetable).subscribe(onCompleted: nil, onError: nil)
                return timetable
        }.asObservable()
        
        observable.subscribe(onNext: { [weak self] (timetable) in
            self?.timetable.accept(timetable)
        }, onError: { (error) in
            
        }, onCompleted: nil, onDisposed: nil)
        
        return observable
    }
    
}
