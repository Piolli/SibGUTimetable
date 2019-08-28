//
// Created by Alexandr on 26/08/2019.
// Copyright (c) 2019 Alexandr. All rights reserved.
//

import Foundation
import FSCalendar

extension FSCalendar {

    func moveTo(state: TimetablePageViewController.PageViewMoveState) {
        guard let selectedDate = self.selectedDate else {
            Logger.logMessageInfo(message: "FSCalendar selectedDate is null")
            return
        }

        let newSelectedDate = Calendar.current.date(byAdding: .day, value: state.rawValue, to: selectedDate)!

        select(newSelectedDate, scrollToDate: true)
    }
}