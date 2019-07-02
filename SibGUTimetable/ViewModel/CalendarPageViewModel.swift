//
//  CalendarPageViewModel.swift
//  SibGUTimetable
//
//  Created by Alexandr on 30/06/2019.
//  Copyright © 2019 Alexandr. All rights reserved.
//

import Foundation

class CalendarPageViewModel {
    
    let month: CalendarParser.CalendarMonth
    let pageIndex: Int
    
    init(pageIndex: Int, month: CalendarParser.CalendarMonth) {
        self.month = month
        self.pageIndex = pageIndex
    }
    
    
}
