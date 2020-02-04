//
//  UserPreferences.swift
//  SibGUTimetable
//
//  Created by Александр Камышев on 04.02.2020.
//  Copyright © 2020 Alexandr. All rights reserved.
//

import Foundation


struct TimetableDetails : Codable, Equatable {
    let groupName: String
    let timestamp: String
}

class UserPreferences {
    
    public static let sharedInstance = UserPreferences()
    
    private init() { }
    private let defaults = UserDefaults.standard
    
    let selectedTimetableDetailsKey = "timetable_group_name"
    
    func saveTimetableDetails(groupName: String, timestamp: String) {
        let encoder = JSONEncoder()
        guard let json = try? encoder.encode(TimetableDetails(groupName: groupName, timestamp: timestamp)) else {
            //TODO logger
            print("JSON is nil")
            return
        }
        
        defaults.set(json, forKey: selectedTimetableDetailsKey)
    }
    
    func getTimetableDetails() -> TimetableDetails? {
        let decoder = JSONDecoder()
        guard let data = defaults.data(forKey: selectedTimetableDetailsKey) else {
            //TODO logger
            print("Data is nil")
            return nil
        }
        return try? decoder.decode(TimetableDetails.self, from: data)
    }
    
    func clearTimetableDetails() {
        defaults.removeObject(forKey: selectedTimetableDetailsKey)
    }
    
}
