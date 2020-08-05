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
    
    let timetableViewController = TimetableViewController()
    
    var rootViewController: UIViewController {
//        return navigationController
        return timetableViewController
    }
    
    init(navigationController: UINavigationController?, timetableDataManager: TimetableDataManager) {
        self.navigationController = navigationController
        self.timetableDataManager = timetableDataManager
        
        timetableViewController.tabBarItem = UITabBarItem(title: "Timetable", image: UIImage(named: "tab_bar_item_timetable"), tag: 1)
        timetableViewController.coordinator = self
        
//        navigationController.pushViewController(ttViewController, animated: true)
//        let navigationController = AppCoordinator.putInNavigationController(ttViewController)
//        self.navigationController = navigationController
    }
    
    func start() {
        timetableViewController.dataManager = timetableDataManager
    }
    
    #if DEBUG
    func startWith(timetable: Timetable) {
        timetableViewController.dataManager = .init(localRepository: FakeLocalTTRepository(timetable: timetable), serverRepository: ServerTTRepositoryTODORemake(timetable: timetable))
    }
    #endif
    
}
