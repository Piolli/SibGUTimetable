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
    private let dataManager: TimetableDataManager
    private let userPreferences: UserPreferences = Assembler.shared.resolve()
    private unowned let coordinator: GroupSearchCoordinator
    
    init(api: APIServer, dataManager: TimetableDataManager, coordinator: GroupSearchCoordinator) {
        self.api = api
        self.dataManager = dataManager
        self.coordinator = coordinator
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
                    .asDriverOnErrorJustReturnEmpty()
            }
        
        let preloadTimetable = input.selectedGroup
            .debug()
            .throttle(.milliseconds(150))
            .map { $0.toTimetableDetails() }
            .flatMapLatest { [weak self] (details) -> Driver<Void> in
                guard let self = self else {
                    logger.error("self = nil")
                    return .empty()
                }
                return self.dataManager.checkTimetableExisting(details)
                    .debug()
                    .trackActivity(isLoadingIndicator)
                    .trackErrors(errorsTracker)
                    .observeOn(MainScheduler.instance)
                    .do(onNext: { () in
                        self.save(timetableDetails: details)
                        self.coordinator.dismissViewController()
                    })
                    .asDriverOnErrorJustReturnEmpty()
            }
            
        return .init(groupsPair: groupPairs,
                     isLoading: isLoadingIndicator.asDriver(onErrorJustReturn: false),
                     preloadCompleted: preloadTimetable,
                     errors: errorsTracker.asDriverOnErrorJustReturnEmpty()
        )
    }
    
    public func save(timetableDetails: TimetableDetails) {
        userPreferences.saveTimetableDetails(timetableDetails)
        logger.debug("new timetableDetails was saved")
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
