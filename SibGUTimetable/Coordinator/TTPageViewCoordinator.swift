//
//  TabTTPageViewCoordinator.swift
//  SibGUTimetable
//
//  Created by Александр Камышев on 04.01.2020.
//  Copyright © 2020 Alexandr. All rights reserved.
//

import Foundation
import UIKit

class TabTTPageViewCoordinator : Coordinator {
    
    weak var navigationController: UINavigationController!
    
    var rootViewController: UIViewController {
        return navigationController
    }
    
    init() {
        let ttViewController = ViewController()
        ttViewController.tabBarItem = UITabBarItem(title: "Timetable", image: UIImage(named: "tab_bar_item_timetable"), tag: 1)
        ttViewController.coordinator = self
        let navigationController = AppCoordinator.putInNavigationController(ttViewController)
        self.navigationController = navigationController
    }
    
    func start() {
        let controller = TTPageViewController()
        navigationController?.pushViewController(controller, animated: true)
    }
    
}
