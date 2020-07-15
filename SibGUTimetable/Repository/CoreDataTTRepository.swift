//
// Created by Alexandr on 30/08/2019.
// Copyright (c) 2019 Alexandr. All rights reserved.
//

import Foundation
import RxSwift
import CoreData

class CoreDataTTRepository : TimetableRepository {
    
    private let persistentConstainer: NSPersistentContainer
    private let context: NSManagedObjectContext
    
    func getTimetable(timetableDetails: TimetableDetails) -> Single<Timetable> {
        return fetchAll()
            .filter { $0.group_name == timetableDetails.groupName }
            .takeLast(1)
            .asSingle()
    }
    
    func saveTimetable(timetable: Timetable) -> Completable {
        return Completable.create { [weak self] (completed) -> Disposable in
            guard let self = self else {
                completed(.error(RxError.unknown))
                return Disposables.create()
            }
            self.context.perform {
                if self.context.hasChanges {
                    do {
                        try self.context.save()
                        completed(.completed)
                    } catch {
                        completed(.error(RxError.unknown))
                    }
                }
            }
            
            return Disposables.create()
        }
    }
    
    init(persistentConstainer: NSPersistentContainer, context: NSManagedObjectContext) {
        self.persistentConstainer = persistentConstainer
        self.context = context
    }
    
    convenience init() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError("Delegate of UIApplication isn't AppDelegate class")
        }
        self.init(persistentConstainer: appDelegate.persistentContainer, context: AppDelegate.backgroundContext)
    }
    
    func fetchAll() -> Observable<Timetable> {
        return Observable.create { [weak self] (observer) -> Disposable in
            guard let self = self else {
                observer.onError(RxError.unknown)
                return Disposables.create()
            }
            
            self.context.perform {
                do {
                    let fetchRequest: NSFetchRequest<Timetable> = Timetable.fetchRequest()
                    let count = try self.context.count(for: fetchRequest)
                    logger.debug("Count of Timetables in presistent store: \(count)")
                    
                    let timetables = try self.context.fetch(fetchRequest)
                    timetables.forEach { (timetable) in
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
