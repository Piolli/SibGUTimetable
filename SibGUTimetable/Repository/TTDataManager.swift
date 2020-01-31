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

class TTDataManager {
    
    let localRepository: TTRepository
    let serverRepository: TTRepository
    
    init(localRepository: TTRepository, serverRepository: TTRepository) {
        self.localRepository = localRepository
        self.serverRepository = serverRepository
    }
    
    func deleteAll() {
        let fetch: NSFetchRequest<NSFetchRequestResult> = Timetable.fetchRequest()
        let deleteReq = NSBatchDeleteRequest(fetchRequest: fetch)
        let result = try? AppDelegate.backgroundContext.execute(deleteReq)
        print("result", result)
    }
    
    func fetchTimetable(groupId: Int, groupName: String) -> Observable<Timetable> {
//        let local = localRepository.getTimetable(groupId: groupId, groupName: groupName)
//        let server = serverRepository.getTimetable(groupId: groupId, groupName: groupName)
//
//        return Observable.create { (observer) -> Disposable in
//
//            var mergedError: Error?
//            var isCompleted = false
//
//            let disp1 = local.subscribe(onSuccess: { (timetable) in
//                observer.onNext(timetable)
//                if isCompleted {
//                    observer.onCompleted()
//                }
//                isCompleted = true
//            }) { (error) in
//                if mergedError != nil {
//                    observer.onError(error)
//                }
//                mergedError = error
//            }
//
//            let disp2 = server.subscribe(onSuccess: { (timetable) in
//                observer.onNext(timetable)
//                if isCompleted {
//                    observer.onCompleted()
//                }
//                isCompleted = true
//            }) { (error) in
//                if mergedError != nil {
//                    observer.onError(error)
//                }
//                mergedError = error
//            }
//
//            return Disposables.create(disp1, disp2)
//        }.debug("Custom")
        
        return localRepository
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
                            self.localRepository.saveTimetable(timetable: $0)
                            return $0
                        }.asObservable()
            }
            .debug("RXSWIFT", trimOutput: false)
    }
    
    convenience init() {
//        //TODO: DI with assembler
////        self.init(localTTRepository: , serverTTRepository: )
        fatalError("DI with assembler")
    }
    
}
