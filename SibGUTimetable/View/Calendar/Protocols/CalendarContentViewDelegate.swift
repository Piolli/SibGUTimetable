//
//  CalendarContentViewDelegate.swift
//  SibGUTimetable
//
//  Created by Alexandr on 07/08/2019.
//  Copyright © 2019 Alexandr. All rights reserved.
//

import Foundation

protocol CalendarContentViewDelegate : AnyObject {
    func cellWasSelectedWith(month: CalendarParser.CalendarMonth, day: Int)
}
