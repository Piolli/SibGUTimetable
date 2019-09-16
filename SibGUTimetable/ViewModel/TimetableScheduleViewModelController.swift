//
// Created by Alexandr on 30/08/2019.
// Copyright (c) 2019 Alexandr. All rights reserved.
//

import Foundation
import RxSwift
import RxRelay

class TimetableScheduleViewModelController {

    let repository: TimetableRepositoryProtocol
    var viewModel: BehaviorRelay<TimetableScheduleViewModel?> = BehaviorRelay(value: nil)

    init(repository: TimetableRepositoryProtocol) {
        self.repository = repository
    }

    func fetchData() {
        repository.getSchedule().subscribe { [weak self] (schedule) in
            if let schedule = schedule.element {
                Logger.logMessageInfo(message: "get schedule with \(schedule.group_name) \(schedule.weeks?.count)")
                self?.viewModel.accept(TimetableScheduleViewModel(schedule: schedule))
            }
        }
    }

}
