//
// Created by Alexandr on 30/08/2019.
// Copyright (c) 2019 Alexandr. All rights reserved.
//

import Foundation
import RxSwift
import CoreData

class CoreDataTTRepository : TTRepository {
    
    private let persistentConstainer: NSPersistentContainer
    private let context = AppDelegate.backgroundContext
    
    func getTimetable(groupId: Int, groupName: String) -> Single<Timetable> {
        return fetchAll()
            .asObservable()
            .flatMap { (ts) -> Observable<Timetable> in
                let sortedTimetables = ts.sorted(by: <)
                return Observable.from(sortedTimetables)
        }
        .filter { $0.group_name == groupName }
        .asObservable()
        .takeLast(1)
        .asSingle()
    }
    
    func saveTimetable(timetable: Timetable) -> Completable {
        return Completable.create { [weak self] (completed) -> Disposable in
            guard let self = self else {
                completed(.error(RxError.unknown))
                return Disposables.create()
            }
            
            if self.context.hasChanges {
                do {
                    try self.context.save()
                    
                } catch {
                    completed(.error(RxError.unknown))
                }
            }
            
            return Disposables.create()
        }
    }
    
    init(persistentConstainer: NSPersistentContainer) {
        self.persistentConstainer = persistentConstainer
    }
    
    convenience init() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError("Delegate of UIApplication isn't AppDelegate class")
        }
        
        self.init(persistentConstainer: appDelegate.persistentContainer)
    }
    
    func fetchAll() -> Single<[Timetable]> {
        return Single.create { [weak self] (single) -> Disposable in
            guard let self = self else {
                single(.error(RxError.unknown))
                return Disposables.create()
            }
            
            self.context.perform {
                do {
                    let fetchRequest: NSFetchRequest<Timetable> = Timetable.fetchRequest()
                    let count = try self.context.count(for: fetchRequest)
                    //TODO: change to logger
                    print("Finded timetables in store: \(count)")
                    
                    if let timetables = try self.context.fetch(fetchRequest) as? [Timetable] {
                        single(.success(timetables))
                    } else {
                        single(.error(RxError.noElements))
                    }
                } catch {
                    single(.error(error))
                    fatalError(error.localizedDescription)
                }
            }
            return Disposables.create()
        }
        .subscribeOn(ConcurrentDispatchQueueScheduler.init(qos: .userInitiated))
    }
    
    enum TTError: Error {
        case noTimetable
        case serverError
        case anotherError
    }

}
