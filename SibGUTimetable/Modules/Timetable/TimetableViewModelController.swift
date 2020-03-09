//
// Created by Alexandr on 30/08/2019.
// Copyright (c) 2019 Alexandr. All rights reserved.
//

import Foundation
import RxSwift
import RxRelay
import RxCocoa

class TimetableViewModelController {

    //TODO: check mutations
    var repository: TimetableRepository
    
    var viewModel: BehaviorRelay<TimetableViewModel?> = BehaviorRelay.init(value: nil)
    var loading: BehaviorRelay<Bool> = BehaviorRelay.init(value: false)
    var error: PublishRelay<Error> = PublishRelay.init()

    internal init(repository: TimetableRepository) {
        self.repository = repository
    }

//    func loadData() {
//        loading.accept(true)
//
//        repository.getTimetable(groupId: 740, groupName: "БПИ16-01").subscribe(onSuccess: { (timetable) in
//            self.viewModel.accept(TTViewModel(schedule: timetable))
//        }) { (error) in
//            self.error.accept(error)
//        }
////        repository.getTimetable(groupName: <#String#>).subscribe(onSuccess: { [weak self] (timetable) in
////            self?.loading.accept(false)
////            Logger.logMessageInfo(message: "get schedule with \(timetable.group_name) \(timetable.weeks?.count)")
////            self?.viewModel.accept(TTViewModel(schedule: timetable))
////        }) { (error) in
////
////        }
////        URLSession.shared.rx.response(request: URLRequest(url: .init(fileURLWithPath: ""))).deb
//
//    }

}
