//
// Created by Alexandr on 27/08/2019.
// Copyright (c) 2019 Alexandr. All rights reserved.
//

import Foundation

extension Date {

    func followingDateByDay() -> Date {
        return Calendar.current.date(byAdding: .day, value: 1, to: self)!
    }

    func previousDateByDay() -> Date {
        return Calendar.current.date(byAdding: .day, value: -1, to: self)!
    }

}