//
//  Week+CoreDataClass.swift
//  SibGUTimetable
//
//  Created by Alexandr on 27/07/2019.
//  Copyright © 2019 Alexandr. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Week)
public class Week: NSManagedObject, Decodable {

    enum CodingKeys: String, CodingKey {
        case number_week
        case days
    }
    
    public convenience required init(from decoder: Decoder) throws {
        
        self.init(context: AppDelegate.context)
        
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        self.number_week = try values.decode(Int16.self, forKey: .number_week)
        
        let daysArray =   try values.decode([Day].self, forKey: .days)
        
        daysArray.forEach { (day) in
            self.addToDays(day)
        }
    }
    
}
