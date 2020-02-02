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
    
    let ttViewController = TimetableViewController()
    
    var rootViewController: UIViewController {
//        return navigationController
        return ttViewController
    }
    
    init(navigationController: UINavigationController?) {
        self.navigationController = navigationController
        
        ttViewController.tabBarItem = UITabBarItem(title: "Timetable", image: UIImage(named: "tab_bar_item_timetable"), tag: 1)
        ttViewController.coordinator = self
//        navigationController.pushViewController(ttViewController, animated: true)
//        let navigationController = AppCoordinator.putInNavigationController(ttViewController)
//        self.navigationController = navigationController
    }
    
    func start() {
        let timetable = FileLoader.shared.getLocalSchedule()
        startWith(timetable: timetable!)
//        let controller = TTPageViewController()
//        controller.viewModelController?.repository = FakeLocalTTRepository()
//        //TODO: make DI for repository
//        navigationController.pushViewController(controller, animated: true)
    }
    
    #if DEBUG
    func startWith(timetable: Timetable) {
//        let controller = ViewController()
        
//        controller.viewModelController?.repository = FakeLocalTTRepository()
//        ServerTTRepositoryTODORemake(timetable: timetable)
//        controller.updateSchedule()
        //TODO: make DI for repository
        navigationController.pushViewController(ttViewController, animated: true)
    }
    #endif
    
}
