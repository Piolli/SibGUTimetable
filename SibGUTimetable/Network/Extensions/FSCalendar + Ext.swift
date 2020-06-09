//
// Created by Alexandr on 26/08/2019.
// Copyright (c) 2019 Alexandr. All rights reserved.
//

import Foundation
import FSCalendar

extension FSCalendar {

    func moveTo(state: CustomizablePageViewMoveDirection) {
        guard let selectedDate = self.selectedDate else {
            logger.error("FSCalendar selectedDate is null")
            return
        }

        let newSelectedDate = Calendar.current.date(byAdding: .day, value: state.rawValue, to: selectedDate)!

        select(newSelectedDate, scrollToDate: true)
    }
    
    func selectToday() {
        self.select(self.today, scrollToDate: true)
    }

    var isSelectedDateEqualsToday: Bool {
        logger.debug("isSelectedDateEqualsToday is \(self.selectedDate) == \(self.today)")
        return self.selectedDate == self.today
    }
}
