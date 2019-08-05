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
        case lessons
    }
    
//    public func encode(to encoder: Encoder) throws {
//        var container = encoder.container(keyedBy: CodingKeys.self)
//        try container.encode(self.header, forKey: .header)
//        try container.encode(self.order, forKey: .header)
//        try container.encode(self.lessons!, forKey: .lessons)
//    }
    
    public convenience required init(from decoder: Decoder) throws {
        self.init(context: AppDelegate.context)
        
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        self.header = try values.decode(String.self, forKey: .header)
        self.order = try values.decode(Int16.self, forKey: .order)
        
        let lessonsArray =   try values.decode([Lesson].self, forKey: .lessons)
        lessonsArray.forEach { (lesson) in
            self.addToLessons(lesson)
        }
        
    }
}
