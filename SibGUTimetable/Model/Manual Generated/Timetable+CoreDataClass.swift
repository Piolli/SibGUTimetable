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
    }
    
    public convenience required init(from decoder: Decoder) throws {
        
        self.init(context: AppDelegate.context)
        
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        self.group_name = try values.decode(String.self, forKey: .group_name)
        
        let weeksArray = try values.decode([Week].self, forKey: .weeks)
        
        weeksArray.forEach { (week) in
            self.addToWeeks(week)
        }
    }
}
