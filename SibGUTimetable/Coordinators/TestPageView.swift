//
//  TestPageView.swift
//  SibGUTimetable
//
//  Created by Александр Камышев on 30.01.2020.
//  Copyright © 2020 Alexandr. All rights reserved.
//

import Foundation

import UIKit
import SnapKit
import SideMenuSwift

class TestPageView : Coordinator {
    
    weak var navigationController: UINavigationController!
    lazy var viewController: TimetablePageViewController = {
        let timetable = FileLoader.shared.getLocalSchedule()!
        let viewModel = TimetableViewModel(schedule: timetable)!
        let vc = TimetablePageViewController(startDate: Date())
        vc.timetableViewModel = viewModel
        return vc
    }()
    
    var rootViewController: UIViewController {
        return viewController
    }
    
    init(navigationController: UINavigationController) {
//        let navigationController = AppCoordinator.putInNavigationController(viewController)
        self.navigationController = navigationController

    }
    
    func start() {
        navigationController.pushViewController(viewController, animated: true)
    }
    
}


