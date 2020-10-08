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
import RxCocoa


class TimetableDetails : NSObject, Codable {
    
    let groupName: String
    let timestamp: String?
    let groupId: Int
    
    internal init(groupId: Int, groupName: String, timestamp: String? = nil) {
        self.groupName = groupName
        self.timestamp = timestamp
        self.groupId = groupId
    }
    
    override var hash: Int {
        return groupId.hashValue / 10 + groupName.hashValue / 10 + (timestamp?.hashValue ?? 0) / 10
    }
    
    override func isEqual(_ object: Any?) -> Bool {
        guard let object = object as? TimetableDetails else {
            return false
        }
        return object.hashValue == self.hashValue
    }
    
}

protocol UserPreferences {
    func saveTimetableDetails(groupId: Int, groupName: String, timestamp: String)
    func saveTimetableDetails(_ timetableDetails: TimetableDetails)
    func getTimetableDetails() -> TimetableDetails?
    func isFirstAppOpening() -> Bool
    func setFirstAppOpening()
    func clearTimetableDetails()
    var timetableDetails: Observable<TimetableDetails?> { get }
}

class DefaultsUserPreferences : NSObject, UserPreferences {
    
    public static let sharedInstance = DefaultsUserPreferences()
    
    private let defaults = UserDefaults.standard
    private let timetableDetailsKey = "timetableDetails"
    private let firstAppOpeningKey = "firstOpeningAppKey"
    private let decoder = JSONDecoder()
    
    var timetableDetails: Observable<TimetableDetails?> {
        return defaults.rx
            .observe(Data.self, timetableDetailsKey)
            .map { [weak self] in
                try? self?.decoder.decode(TimetableDetails.self, from: $0 ?? Data())
            }
    }

    func saveTimetableDetails(groupId: Int, groupName: String, timestamp: String) {
        let timetableDetails = TimetableDetails(groupId: groupId, groupName: groupName, timestamp: timestamp)
        self.saveTimetableDetails(timetableDetails)
    }
    
    func saveTimetableDetails(_ timetableDetails: TimetableDetails) {
        let encoder = JSONEncoder()
        guard let json = try? encoder.encode(timetableDetails) else {
            logger.error("JSON is nil")
            return
        }
        defaults.set(json, forKey: timetableDetailsKey)
    }
    
    func getTimetableDetails() -> TimetableDetails? {
        guard let data = defaults.data(forKey: timetableDetailsKey) else {
            logger.error("Data is nil")
            return nil
        }
        return try? decoder.decode(TimetableDetails.self, from: data)
    }
    
    func clearTimetableDetails() {
        defaults.removeObject(forKey: timetableDetailsKey)
    }
    
    func isFirstAppOpening() -> Bool {
        return (defaults.value(forKey: firstAppOpeningKey) as? Bool) ?? true
    }
    
    func setFirstAppOpening() {
        defaults.setValue(false, forKey: firstAppOpeningKey)
    }
    
    @objc fileprivate func didChangeValue(notification: Notification) {
        logger.debug("Notification description: \(notification.description)")
        dump(notification)
    }
    
}
