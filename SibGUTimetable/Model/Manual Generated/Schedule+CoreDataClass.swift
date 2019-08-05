//
//  Schedule+CoreDataClass.swift
//  SibGUTimetable
//
//  Created by Alexandr on 27/07/2019.
//  Copyright © 2019 Alexandr. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Schedule)
public class Schedule: NSManagedObject, Decodable {
    
    enum CodingKeys: String, CodingKey {
        case group_name
        case weeks
    }
    
    public convenience required init(from decoder: Decoder) throws {
        
        self.init(context: AppDelegate.context)
        
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        self.group_name = try values.decode(String.self, forKey: .group_name)
        
        let weeksArray =   try values.decode([Week].self, forKey: .weeks)
        
        weeksArray.forEach { (week) in
            self.addToWeeks(week)
        }
    }
    
}
