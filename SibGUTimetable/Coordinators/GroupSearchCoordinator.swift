//
//  GroupSearchCoordinator.swift
//  SibGUTimetable
//
//  Created by Александр Камышев on 23.01.2020.
//  Copyright © 2020 Alexandr. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class GroupSearchCoordinator : Coordinator {
    
    var groupSearchViewController: GroupSearchViewController!
    let appCoordinator: AppCoordinator
    
    var rootViewController: UIViewController {
        return groupSearchViewController
    }

    init(appCoordinator: AppCoordinator, dataManager: TimetableDataManager) {
        self.appCoordinator = appCoordinator
        let viewModel = GroupSearchViewModel(api: Assembler.shared.resolve(), dataManager: dataManager, coordinator: self)
        groupSearchViewController = GroupSearchViewController(viewModel: viewModel)
    }
    
    func dismissViewController() {
        rootViewController.navigationController?.popViewController(animated: true)
    }
    
    func start() {
//        let controller = TTPageViewController()
//        navigationController?.pushViewController(controller, animated: true)
    }
    
}
