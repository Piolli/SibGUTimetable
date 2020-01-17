//
// Created by Alexandr on 30/08/2019.
// Copyright (c) 2019 Alexandr. All rights reserved.
//

import Foundation
import RxSwift
import RxRelay
import RxCocoa

class TTViewModelController {

    let repository: TTRepository
    
    var viewModel: BehaviorRelay<TTViewModel?> = BehaviorRelay.init(value: nil)
    var loading: BehaviorRelay<Bool> = BehaviorRelay.init(value: false)
    var error: PublishRelay<Error> = PublishRelay.init()

    internal init(repository: TTRepository) {
        self.repository = repository
    }

    func loadData() {
        loading.accept(true)
        
        repository.getSchedule().subscribe(onSuccess: { [weak self] (timetable) in
            self?.loading.accept(false)
            Logger.logMessageInfo(message: "get schedule with \(timetable.group_name) \(timetable.weeks?.count)")
            self?.viewModel.accept(TTViewModel(schedule: timetable))
        }) { (error) in
            
        }
//        URLSession.shared.rx.response(request: URLRequest(url: .init(fileURLWithPath: ""))).deb
        
    }

}
