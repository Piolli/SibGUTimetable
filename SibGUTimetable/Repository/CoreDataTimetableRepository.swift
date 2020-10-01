//
// Created by Alexandr on 30/08/2019.
// Copyright (c) 2019 Alexandr. All rights reserved.
//

import Foundation
import RxSwift
import CoreData

class CoreDataTimetableRepository : TimetableRepository {
    
    private let context: NSManagedObjectContext
    
    //TODO: rewrite method because there's only one timetable for each group_name
    func getTimetable(_ timetableDetails: TimetableDetails) -> Single<TimetableFetchResult> {
        return fetchAll(with: timetableDetails)
            .map({ (timetable) -> TimetableFetchResult in
                return TimetableFetchResult(timetable: timetable, storage: .local, error: nil)
            })
            .catchError { (error) -> Observable<TimetableFetchResult> in
                return .just(TimetableFetchResult(timetable: nil, storage: .local, error: error))
            }
            .ifEmpty(default: TimetableFetchResult(timetable: nil, storage: .local, error: TimetableDataManagerError.emptyStore))
            .takeLast(1)
            .asSingle()
    }
    
    private func delete(object: NSManagedObject) throws {
        context.performAndWait { [weak self] in
            guard let self = self else {
                logger.error("self is nil")
                return
            }
            self.context.delete(object)
            logger.debug("NSManagedObject was deleted")
        }
    }
    
    private func saveContext() throws {
        context.performAndWait { [weak self] in
            guard let self = self else {
                logger.error("self is nil")
                return
            }
            if self.context.hasChanges {
                do {
                    try self.context.save();
                    logger.debug("CoreData NSManagedObjectContext was saved")
                } catch {
                    logger.error("CoreData NSManagedObjectContext wasn't saved")
                }
            }
        }
    }
    
    func save(timetable: Timetable) -> Completable {
        return Completable.create { (completed) -> Disposable in
            guard let groupName = timetable.group_name else {
                fatalError("Timetable object is invalid")
            }
            
            self.context.performAndWait {
                do {
                    let fetchRequest: NSFetchRequest<Timetable> = Timetable.fetchRequest()
                    fetchRequest.predicate = .init(format: "group_name == %@", groupName)
                    let count = try self.context.count(for: fetchRequest)
                    logger.debug("Count of Timetables with duplicate group_name: \(count)")
                    
                    let timetables = try self.context.fetch(fetchRequest)
                    timetables
                        .sorted(by: <)
                        //Drop down newest timetable
                        .dropLast()
                        .forEach { (timetable) in
                            try! self.delete(object: timetable)
                        }
                    try self.saveContext()
                    completed(.completed)
                } catch {
                    logger.error("Fetch timetable from CoreData storage: \(error.localizedDescription)")
                    completed(.error(error))
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
    
    func fetchAll(with timetableDetails: TimetableDetails) -> Observable<Timetable> {
        return Observable.create { [weak self] (observer) -> Disposable in
            guard let self = self else {
                observer.onError(RxError.unknown)
                return Disposables.create()
            }
            
            self.context.performAndWait {
                do {
                    let fetchRequest: NSFetchRequest<Timetable> = Timetable.fetchRequest()
                    fetchRequest.predicate = NSPredicate(format: "group_name == %@", timetableDetails.groupName)
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
