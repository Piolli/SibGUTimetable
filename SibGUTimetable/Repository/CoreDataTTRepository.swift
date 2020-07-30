//
// Created by Alexandr on 30/08/2019.
// Copyright (c) 2019 Alexandr. All rights reserved.
//

import Foundation
import RxSwift
import CoreData

class CoreDataTTRepository : TimetableRepository {
    
    private let context: NSManagedObjectContext
    
    func getTimetable(timetableDetails: TimetableDetails) -> Single<Timetable> {
        return fetchAll()
            .filter { $0.group_name == timetableDetails.groupName }
            .takeLast(1)
            .asSingle()
    }
    
    func save(timetable: Timetable) -> Completable {
        return Completable.create { [weak self] (completed) -> Disposable in
            guard let self = self else {
                completed(.error(RxError.unknown))
                return Disposables.create()
            }
            self.context.perform {
                if self.context.hasChanges {
                    do {
                        try self.context.save()
                        logger.info("CoreData NSManagedObjectContext was saved")
                        completed(.completed)
                    } catch {
                        logger.error("CoreData NSManagedObjectContext wasn't saved")
                        completed(.error(error))
                    }
                }
            }
            
            return Disposables.create()
        }
    }
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    @objc private func compareUpdateTimestamp(t1: Timetable, t2: Timetable) -> Bool {
        return false
    }
    
    func fetchAll() -> Observable<Timetable> {
        return Observable.create { [weak self] (observer) -> Disposable in
            guard let self = self else {
                observer.onError(RxError.unknown)
                return Disposables.create()
            }
            
            self.context.performAndWait {
                do {
                    let fetchRequest: NSFetchRequest<Timetable> = Timetable.fetchRequest()
                    
                    let count = try self.context.count(for: fetchRequest)
                    logger.debug("Count of Timetables in persistent store: \(count)")
                    
                    let timetables = try self.context.fetch(fetchRequest)
                    timetables
                        .sorted(by: <)
                        .forEach { (timetable) in
                        observer.onNext(timetable)
                    }
                    observer.onCompleted()
                } catch {
                    observer.onError(error)
                    logger.error("Fetch timetable from core data storage. Error: \(error.localizedDescription)")
                }
            }
             
            return Disposables.create()
        }
    }
    
    enum TTError: Error {
        case noTimetable
        case serverError
        case anotherError
        case doNotSaved
    }

}
