//
//  UserPreferencesAssembler.swift
//  SibGUTimetable
//
//  Created by Александр Камышев on 06.06.2020.
//  Copyright © 2020 Alexandr. All rights reserved.
//

import Foundation
import RxSwift
import RxRelay

protocol UserPreferencesAssembler {
    
    func resolve() -> UserPreferences
    
}


extension UserPreferencesAssembler {
    
    func resolve() -> UserPreferences {
        return DefaultsUserPreferences.sharedInstance
    }
    
}

class FakeUserPreferences : UserPreferences {
    
    var timetableDetails: Observable<TimetableDetails?> = .empty()
    
    func isFirstAppOpening() -> Bool {
        return true
    }
    
    func setFirstAppOpening() {
        
    }
    
    func saveTimetableDetails(groupId: Int, groupName: String, timestamp: String) {
        
    }
    
    func saveTimetableDetails(_ timetableDetails: TimetableDetails) {
        
    }
    
    func getTimetableDetails() -> TimetableDetails? {
        return TimetableDetails(groupId: 10, groupName: "БПИ16-01", timestamp: nil)
    }
    
    func clearTimetableDetails() {
        
    }
    
    var timetableDetailsDidChanged: PublishRelay<TimetableDetails?> = .init()
    
}

protocol FakeUserPreferencesAssembler : UserPreferencesAssembler { }

extension FakeUserPreferencesAssembler {
    
    func resolve() -> UserPreferences {
        return FakeUserPreferences.init()
    }
    
}
