//
//  RepositoryAssembler.swift
//  SibGUTimetable
//
//  Created by Александр Камышев on 06.06.2020.
//  Copyright © 2020 Alexandr. All rights reserved.
//

import Foundation

protocol RepositoryAssembler {
    
    func resolveLocal() -> TimetableRepository
    
    func resolveNetwork() -> TimetableRepository
    
    func resolve() -> TimetableDataManager
    
}

extension RepositoryAssembler {
    
    func resolveLocal() -> TimetableRepository {
        return CoreDataTTRepository()
    }
    
    func resolveNetwork() -> TimetableRepository {
        return ServerRepository()
    }
    
    func resolve() -> TimetableDataManager {
        return TimetableDataManager(localRepository: resolveLocal(), serverRepository: resolveNetwork())
    }
    
}

protocol FakeRepositoryAssembler : RepositoryAssembler { }

extension FakeRepositoryAssembler {
    
    func resolveLocal() -> TimetableRepository {
        guard let timetable = FileLoader.shared.getLocalSchedule() else {
            fatalError("Local timetable doesn't exist")
        }
        
        return FakeLocalTTRepository(timetable: timetable)
    }
    
    func resolveNetwork() -> TimetableRepository {
        guard let timetable = FileLoader.shared.getLocalSchedule() else {
            fatalError("Local timetable doesn't exist")
        }
        
        return ServerTTRepositoryTODORemake(timetable: timetable)
    }
    
}
