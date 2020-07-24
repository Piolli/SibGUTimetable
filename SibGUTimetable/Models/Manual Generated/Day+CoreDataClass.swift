//
//  Day+CoreDataClass.swift
//  SibGUTimetable
//
//  Created by Alexandr on 27/07/2019.
//  Copyright © 2019 Alexandr. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Day)
public class Day: NSManagedObject, Decodable {
    enum CodingKeys: String, CodingKey {
        case header
        case order
        case lessonGroups
    }
    
    public convenience required init(from decoder: Decoder) throws {
        guard let context = decoder.userInfo[CodingUserInfoKey.context!] as? NSManagedObjectContext else {
            fatalError("Doesn't provide NSManagedObjectContext for CoreData Object")
        }
        
        self.init(context: context)
        
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        self.header = try values.decode(String.self, forKey: .header)
        self.order = try values.decode(Int16.self, forKey: .order)
        
        let lessonGroupsArray = try values.decode([LessonGroup].self, forKey: .lessonGroups)
        lessonGroupsArray.forEach { (group) in
            self.addToLessonGroups(group)
        }
        
    }
}
