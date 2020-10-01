//
//  TabTTPageViewCoordinator.swift
//  SibGUTimetable
//
//  Created by Александр Камышев on 04.01.2020.
//  Copyright © 2020 Alexandr. All rights reserved.
//

import Foundation
import UIKit

class TimetableCoordinator : Coordinator {
    
    weak var navigationController: UINavigationController!
    weak var timetableDataManager: TimetableDataManager!
    
    var timetableViewController: TimetableViewController!
    
    var rootViewController: UIViewController {
        return timetableViewController
    }
    
    init(navigationController: UINavigationController?, timetableDataManager: TimetableDataManager) {
        self.navigationController = navigationController
        self.timetableDataManager = timetableDataManager

        timetableViewController = TimetableViewController(viewModel: TimetableViewModel(dataManager: timetableDataManager))
        timetableViewController.coordinator = self
        //        start()
    }
    
    func start() {
//        let dataManager: TimetableDataManager = Assembler.shared.resolve()
//        timetableViewController = TimetableViewController(viewModel: TimetableViewModel(dataManager: dataManager))
//        timetableViewController.coordinator = self
    }
    
}
