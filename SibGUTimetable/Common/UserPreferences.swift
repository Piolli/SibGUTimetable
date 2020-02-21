//
//  UserPreferences.swift
//  SibGUTimetable
//
//  Created by Александр Камышев on 04.02.2020.
//  Copyright © 2020 Alexandr. All rights reserved.
//

import Foundation
import RxSwift
import RxRelay


class TimetableDetails : NSObject, Codable {
    
    let groupName: String
    let timestamp: String?
    let groupId: Int
    
    internal init(groupId: Int, groupName: String, timestamp: String? = nil) {
        self.groupName = groupName
        self.timestamp = timestamp
        self.groupId = groupId
    }
    
}

extension UserDefaults {
    
    @objc dynamic var timetableDetails: Data {
        return data(forKey: "timetableDetails") ?? Data()
    }
    
}

class UserPreferences : NSObject {
    
    public static let sharedInstance = UserPreferences()
    public let timetableDetailsDidChanged: PublishRelay<TimetableDetails?> = .init()
    private let defaults = UserDefaults.standard
    let selectedTimetableDetailsKey = "timetableDetails"
    var observer: NSKeyValueObservation!
    
    
    private override init() {
        super.init()
        observer = defaults.observe(\.timetableDetails, options: .new, changeHandler: { (defaults, value) in
            print("some", value.newValue, value.oldValue)
            if let data = value.newValue {
                let object = try? JSONDecoder().decode(TimetableDetails.self, from: data)
                print(object?.groupName, object?.timestamp)
            }
        })
    }
    
    deinit {
        observer.invalidate()
    }
   
    func saveTimetableDetails(groupId: Int, groupName: String, timestamp: String) {
        let timetableDetails = TimetableDetails(groupId: groupId, groupName: groupName, timestamp: timestamp)
        self.saveTimetableDetails(timetableDetails)
    }
    
    func saveTimetableDetails(_ timetableDetails: TimetableDetails) {
        let encoder = JSONEncoder()
        guard let json = try? encoder.encode(timetableDetails) else {
            //TODO logger
            print("JSON is nil")
            return
        }
        defaults.set(json, forKey: selectedTimetableDetailsKey)
        timetableDetailsDidChanged.accept(timetableDetails)
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
        timetableDetailsDidChanged.accept(nil)
    }
    
    @objc fileprivate func didChangeValue(notification: Notification) {
        print("Notification description: ",notification.description)
        
        dump(notification)
    }
    
    
}
