//
//  Timetable+CoreDataClass.swift
//  
//
//  Created by Александр Камышев on 05.01.2020.
//
//

import Foundation
import CoreData

@objc(Timetable)
public class Timetable: NSManagedObject, Decodable {
    
    enum CodingKeys: String, CodingKey {
        case group_name
        case weeks
        case update_timestamp
    }
    
    var updateTimestampTime: TimeInterval {
        return TimeInterval.init(Double(updateTimestamp ?? "-1.0") ?? -1.0)
    }
    
    public convenience required init(from decoder: Decoder) throws {
        guard let context = decoder.userInfo[CodingUserInfoKey.context!] as? NSManagedObjectContext else {
            fatalError("Doesn't provide NSManagedObjectContext for CoreData Object")
        }
        
        self.init(context: context)
        
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        group_name = try values.decode(String.self, forKey: .group_name)
        let weeksArray = try values.decode([Week].self, forKey: .weeks)
        
        weeksArray.forEach { (week) in
            addToWeeks(week)
        }
        
        updateTimestamp = try values.decode(String.self, forKey: .update_timestamp)
    }
}

//MARK: - `Comparable
extension Timetable : Comparable {
    
    public static func < (lhs: Timetable, rhs: Timetable) -> Bool {
        return lhs.updateTimestampTime < rhs.updateTimestampTime
    }
    
}

// MARK: – Sorted NSFetchRequest
extension Timetable {
    
    public class func sortByUpdateTimestampFetchRequest(ascending: Bool) -> NSFetchRequest<Timetable> {
        let fetchRequest: NSFetchRequest<Timetable> = Timetable.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "updateTimestamp", ascending: ascending, comparator: { (t1, t2) -> ComparisonResult in
            let time1 = Double(t1 as! String)!
            let time2 = Double(t2 as! String)!
            if time1 < time2 {
                return .orderedAscending
            } else if time1 > time2 {
                return .orderedDescending
            } else {
                return .orderedSame
            }
        })]
        return fetchRequest
    }
    
}
