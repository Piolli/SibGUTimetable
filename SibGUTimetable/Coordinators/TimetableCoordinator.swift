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
    
    let timetableViewController = TimetableViewController()
    
    var rootViewController: UIViewController {
//        return navigationController
        return timetableViewController
    }
    
    init(navigationController: UINavigationController?) {
        self.navigationController = navigationController
        
        timetableViewController.tabBarItem = UITabBarItem(title: "Timetable", image: UIImage(named: "tab_bar_item_timetable"), tag: 1)
        timetableViewController.coordinator = self
//        navigationController.pushViewController(ttViewController, animated: true)
//        let navigationController = AppCoordinator.putInNavigationController(ttViewController)
//        self.navigationController = navigationController
    }
    
    func start() {
//        let controller = TTPageViewController()
//        controller.viewModelController?.repository = FakeLocalTTRepository()
//        //TODO: make DI for repository
//        navigationController.pushViewController(controller, animated: true)
        //TODO: make DI for repository
        timetableViewController.dataManager = TimetableDataManager(localRepository: CoreDataTTRepository(), serverRepository: ServerRepository())
    }
    
    #if DEBUG
    func startWith(timetable: Timetable) {
        timetableViewController.dataManager = .init(localRepository: FakeLocalTTRepository(timetable: timetable), serverRepository: ServerTTRepositoryTODORemake(timetable: timetable))
    }
    #endif
    
}
