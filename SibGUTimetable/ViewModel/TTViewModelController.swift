//
// Created by Alexandr on 30/08/2019.
// Copyright (c) 2019 Alexandr. All rights reserved.
//

import Foundation
import RxSwift
import RxRelay

class TTViewModelController {

    let repository: TTRepository
    var viewModel: BehaviorRelay<TTViewModel?> = BehaviorRelay(value: nil)

    internal init(repository: TTRepository) {
        self.repository = repository
    }

    func fetchData() {
        repository.getSchedule().subscribe { [weak self] (schedule) in
            if let schedule = schedule.element {
                Logger.logMessageInfo(message: "get schedule with \(schedule.group_name) \(schedule.weeks?.count)")
                self?.viewModel.accept(TTViewModel(schedule: schedule))
            }
        }
    }

}
