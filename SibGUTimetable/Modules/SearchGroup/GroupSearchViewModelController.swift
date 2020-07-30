//
//  GroupSearchViewModelController.swift
//  SibGUTimetable
//
//  Created by Александр Камышев on 21.01.2020.
//  Copyright © 2020 Alexandr. All rights reserved.
//

import Foundation
import RxSwift
import RxRelay
import RxCocoa

enum GroupSearchError : Error {
    case notFoundGroup
}

class GroupSearchViewModelController {
    
    private let api: APIServer
    public let viewModel: PublishRelay<GroupSearchViewModel>
    public let error: PublishRelay<Error>
    public let loading: PublishRelay<Bool>
    private let disposeBag = DisposeBag()
    private let userPreferences: UserPreferences = Assembler.shared.resolve()
    
    init(api: APIServer) {
        self.api = api
        self.viewModel = .init()
        self.loading = .init()
        self.error = .init()
    }
    
    public func searchGroup(query: String) {
        loading.accept(true)
        api.findGroup(queryGroupName: query)
            .observeOn(MainScheduler.instance)
            .subscribe(onSuccess: { [weak self] (groupPairs) in
            self?.viewModel.accept(GroupSearchViewModel(groupPairs: groupPairs))
            self?.loading.accept(false)
        }) { [weak self] (error) in
            self?.error.accept(error)
            self?.loading.accept(false)
        }.disposed(by: disposeBag)
    }
    
    public func save(timetableDetails: TimetableDetails) {
        userPreferences.saveTimetableDetails(timetableDetails)
    }
    
}
