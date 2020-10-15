//
//  GroupSearchViewModel.swift
//  SibGUTimetable
//
//  Created by Александр Камышев on 21.01.2020.
//  Copyright © 2020 Alexandr. All rights reserved.
//

import Foundation
import RxSwift
import RxRelay
import RxCocoa
import RxSwiftUtilities

class GroupSearchViewModel {
    
    private let api: APIServer
    private let userPreferences: UserPreferences = Assembler.shared.resolve()
    
    init(api: APIServer) {
        self.api = api
    }
    
    func transform(input: Input) -> Output {
        let isLoadingIndicator = ActivityIndicator()
        let groupPairs = input.groupName
            .debug()
            .throttle(.milliseconds(300))
            .distinctUntilChanged()
            .filter { !$0.isEmpty }
            .flatMapLatest {
                self.api.findGroup(queryGroupName: $0)
                    .trackActivity(isLoadingIndicator).asDriver(onErrorJustReturn: [])
            }.asDriver(onErrorJustReturn: [])
        return .init(groupsPair: groupPairs, isLoading: isLoadingIndicator.asDriver(onErrorJustReturn: false))
    }
    
    public func save(timetableDetails: TimetableDetails) {
        userPreferences.saveTimetableDetails(timetableDetails)
    }
    
}

extension GroupSearchViewModel: ViewModel {
    struct Input {
        let groupName: Driver<String>
    }
    
    struct Output {
        let groupsPair: Driver<[GroupPairIDName]>
        let isLoading: Driver<Bool>
    }
}
