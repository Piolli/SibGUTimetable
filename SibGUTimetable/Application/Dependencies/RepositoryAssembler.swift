//
//  RepositoryAssembler.swift
//  SibGUTimetable
//
//  Created by Александр Камышев on 06.06.2020.
//  Copyright © 2020 Alexandr. All rights reserved.
//

import Foundation
import UIKit
import CoreData

protocol RepositoryAssembler {
    
    func resolveLocal() -> TimetableRepository
    
    func resolveNetwork() -> TimetableRepository
    
    func resolve() -> TimetableDataManager
    
}

extension RepositoryAssembler {
    
    func resolveLocal() -> TimetableRepository {
        fatalError()
//        return CoreDataTTRepository(context: AppDelegate.backgroundContext)
    }
    
    func resolveNetwork() -> TimetableRepository {
        fatalError()
//        return ServerRepository(context: AppDelegate.backgroundContext)
    }
    
    func resolve() -> TimetableDataManager {
        guard let delegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError("AppDelegate is nil and context too")
        }
        let context = delegate.persistentContainer.newBackgroundContext()
        return TimetableDataManager(localRepository: CoreDataTimetableRepository(context: context), serverRepository: ServerRepository(context: context))
    }
    
}

protocol FakeRepositoryAssembler : RepositoryAssembler { }

extension FakeRepositoryAssembler {
    
    func getFakeTimetable() -> Timetable {
        let decoder = JSONDecoder()
        guard let delegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError("AppDelegate is nil and context too")
        }
        let context = delegate.persistentContainer.viewContext
        decoder.userInfo[CodingUserInfoKey.context!] = context
        guard let timetable = FileLoader.shared.getLocalSchedule(decoder: decoder) else {
            fatalError("Network timetable doesn't exist")
        }
        return timetable
    }
    
    func resolveLocal() -> TimetableRepository {
        return FakeLocalTTRepository(timetable: getFakeTimetable())
    }
    
    func resolveNetwork() -> TimetableRepository {
        return ServerTTRepositoryTODORemake(timetable: getFakeTimetable())
    }
    
    func resolve() -> TimetableDataManager {
        return TimetableDataManager(localRepository: resolveLocal(), serverRepository: resolveNetwork())
    }
    
}

