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
    private let disposeBag = DisposeBag()
    
    init(api: APIServer) {
        self.api = api
        self.viewModel = .init()
        self.error = .init()
    }
    
    public func searchGroup(query: String) {
        api.findGroup(queryGroupName: query).subscribe(onSuccess: { [weak self] (groupPairs) in
            self?.viewModel.accept(GroupSearchViewModel(groupPairs: groupPairs))
        }) { [weak self] (error) in
            self?.error.accept(error)
        }.disposed(by: disposeBag)
    }
    
}
