//
//  GroupSearchViewModel.swift
//  SibGUTimetable
//
//  Created by Александр Камышев on 21.01.2020.
//  Copyright © 2020 Alexandr. All rights reserved.
//

import Foundation
import RxSwift
import RxRelay

class GroupSearchViewModel {
    
    var groupPairs: [PairIDName] = []
    
    init(groupPairs: [PairIDName]) {
        self.groupPairs = groupPairs
    }
    
}
