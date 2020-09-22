//
//  Acknow + Ext.swift
//  SibGUTimetable
//
//  Created by Александр Камышев on 22.09.2020.
//  Copyright © 2020 Alexandr. All rights reserved.
//

import Foundation
import AcknowList

extension Acknow: Decodable {
    
    enum CodingKeys: CodingKey {
        case title, text, license
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let title = try container.decodeIfPresent(String.self, forKey: .title)
        let text = try container.decodeIfPresent(String.self, forKey: .text)
        let license = try container.decodeIfPresent(String.self, forKey: .license)
        self.init(title: title ?? "", text: text ?? "", license: license ?? nil)
    }
    
}
