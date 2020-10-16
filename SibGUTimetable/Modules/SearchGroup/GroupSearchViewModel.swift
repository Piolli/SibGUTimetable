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
        let errorsTracker = PublishRelay<Error>()
        let groupPairs = input.groupName
            .debug()
            .throttle(.milliseconds(300))
            .distinctUntilChanged()
            .filter { !$0.isEmpty }
            .flatMapLatest { [weak self] groupName -> Driver<[GroupPairIDName]> in
                guard let self = self else {
                    logger.error("self = nil")
                    return .empty()
                }
                return self.api.findGroup(queryGroupName: groupName)
                    .trackActivity(isLoadingIndicator)
                    .trackErrors(errorsTracker)
                    .asDriver { (error) -> Driver<[GroupPairIDName]> in
                        logger.error("SOME RROR")
                        return .empty()
                    }
            }
        
        let preloadTimetable = input
            .selectedGroup
            .distinctUntilChanged {
                $0.description
            }
            .map { _ in return Void() }
            
        return .init(groupsPair: groupPairs, isLoading: isLoadingIndicator.asDriver(onErrorJustReturn: false), preloadCompleted: preloadTimetable, errors: errorsTracker.asDriver(onErrorRecover: { (error) -> Driver<Error> in
            logger.critical("Errors emitter got error :)")
            return .empty()
        }))
    }
    
    public func save(timetableDetails: TimetableDetails) {
        userPreferences.saveTimetableDetails(timetableDetails)
    }
    
}

extension GroupSearchViewModel: ViewModel {
    struct Input {
        let groupName: Driver<String>
        let selectedGroup: Driver<GroupPairIDName>
    }
    
    struct Output {
        let groupsPair: Driver<[GroupPairIDName]>
        let isLoading: Driver<Bool>
        let preloadCompleted: Driver<Void>
        let errors: Driver<Error>
    }
}
