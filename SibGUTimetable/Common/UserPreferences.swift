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

protocol UserPreferences {
    func saveTimetableDetails(groupId: Int, groupName: String, timestamp: String)
    func saveTimetableDetails(_ timetableDetails: TimetableDetails)
    func getTimetableDetails() -> TimetableDetails?
    func isFirstAppOpening() -> Bool
    func setFirstAppOpening()
    func clearTimetableDetails()
    var timetableDetailsDidChanged: PublishRelay<TimetableDetails?> { get }
}

class DefaultsUserPreferences : NSObject, UserPreferences {
    
    public static let sharedInstance = DefaultsUserPreferences()
    public let timetableDetailsDidChanged: PublishRelay<TimetableDetails?> = .init()

    let selectedTimetableDetailsKey = "timetableDetails"
    let firstAppOpeningKey = "firstOpeningAppKey"
    var observer: NSKeyValueObservation!

    private let defaults = UserDefaults.standard
    
    private override init() {
        super.init()
        observer = defaults.observe(\.timetableDetails, options: .new, changeHandler: { (defaults, value) in
            logger.debug("\(value.newValue), \(value.oldValue)")
            if let data = value.newValue {
                let object = try? JSONDecoder().decode(TimetableDetails.self, from: data)
                logger.debug("\(object?.groupName), \(object?.timestamp)")
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
            logger.error("JSON is nil")
            return
        }
        defaults.set(json, forKey: selectedTimetableDetailsKey)
        timetableDetailsDidChanged.accept(timetableDetails)
    }
    
    func getTimetableDetails() -> TimetableDetails? {
        let decoder = JSONDecoder()
        guard let data = defaults.data(forKey: selectedTimetableDetailsKey) else {
            logger.error("Data is nil")
            return nil
        }
        return try? decoder.decode(TimetableDetails.self, from: data)
    }
    
    func clearTimetableDetails() {
        defaults.removeObject(forKey: selectedTimetableDetailsKey)
        timetableDetailsDidChanged.accept(nil)
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
