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
        case order_week
        case days
    }
    
    public convenience required init(from decoder: Decoder) throws {
        guard let context = decoder.userInfo[CodingUserInfoKey.context!] as? NSManagedObjectContext else {
            fatalError("Doesn't provide NSManagedObjectContext for CoreData Object")
        }
        
        self.init(context: context)
        
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.order_week = try values.decode(Int16.self, forKey: .order_week)
        let daysArray = try values.decode([Day].self, forKey: .days)
        daysArray.forEach { (day) in
            self.addToDays(day)
        }
    }
    
}
