//
//  Lesson+CoreDataClass.swift
//  SibGUTimetable
//
//  Created by Alexandr on 27/07/2019.
//  Copyright © 2019 Alexandr. All rights reserved.
//
//

import Foundation
import CoreData
import UIKit

@objc(Lesson)
public class Lesson: NSManagedObject, Codable {
    
    enum CodingKeys: String, CodingKey {
        case end_time
        case name
        case office
        case start_time
        case teacher
        case type
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.end_time, forKey: .end_time)
        try container.encode(self.name, forKey: .name)
        try container.encode(self.office, forKey: .office)
        try container.encode(self.start_time, forKey: .start_time)
        try container.encode(self.teacher, forKey: .teacher)
        try container.encode(self.type, forKey: .type)
    }
    
    
    
    public required convenience init(from decoder: Decoder) throws {
        
        self.init(context: AppDelegate.context)
        
        // Decode
        let values =      try decoder.container(keyedBy: CodingKeys.self)
        self.end_time =   try values.decode(String.self, forKey: .end_time)
        self.name =       try values.decode(String.self, forKey: .name)
        self.office  =    try values.decode(String.self, forKey: .office)
        self.start_time = try values.decode(String.self, forKey: .start_time)
        self.teacher =    try values.decode(String.self, forKey: .teacher)
        self.type =    try values.decode(String.self, forKey: .type)
    }
    
}

extension CodingUserInfoKey {
    static let context = CodingUserInfoKey(rawValue: "context")
}
