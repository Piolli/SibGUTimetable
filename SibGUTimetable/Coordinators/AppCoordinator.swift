//
//  AppCoordinator.swift
//  SibGUTimetable
//
//  Created by Александр Камышев on 04.01.2020.
//  Copyright © 2020 Alexandr. All rights reserved.
//

import Foundation
import UIKit
import SideMenuSwift

class AppCoordinator : NSObject, Coordinator {
    
    private let window: UIWindow
    private var tabBarController: UITabBarController!
    private var navigationController: UINavigationController
    lazy var sideCoordinator = SideMenuCoordinator(mainCoordinator: TimetableCoordinator(navigationController: nil), menuSections: [
        ///Observe for teachers and their lessons
        ("Add Timetable Section", SimpleCoordinator()),
        ("Settings", SimpleCoordinator()),
        ("About", SimpleCoordinator())
    ])
    private lazy var rootCoordinator: Coordinator = {
//        return TestPageView(navigationController: self.navigationController)
        
        return sideCoordinator
    }()
    
    var rootViewController: UIViewController {
        return rootCoordinator.rootViewController
//        return navigationController
//        return tabBarController
    }
    
    internal init(window: UIWindow) {
        self.window = window
        self.navigationController = UINavigationController()
        
        
        //TODO: refactor to another coordinator `TabBarCoordinator`
//        let tabBarController = UITabBarController()
//        tabBarController.viewControllers = [
////            TabTTPageViewCoordinator().rootViewController
//            rootCoordinator.rootViewController
//        ]
//        self.tabBarController = tabBarController
//        rootCoordinator = makeRootCoordinator()
    }

    
    func start() {
        window.rootViewController = rootViewController
        rootCoordinator.start()
        window.makeKeyAndVisible()
    }
    
}

//MARK: - Setup root view controller (tabBar)
extension AppCoordinator {
    //TODO: refactor it to differents tab coordinators
    fileprivate static func setupRootViewController() -> UITabBarController {
        let tabBarController = UITabBarController()
        tabBarController.tabBar.shadowImage = UIImage()
        
        let vc1 = UIViewController()
        vc1.title = "In progress"
        vc1.view.backgroundColor = .white
        vc1.tabBarItem = UITabBarItem(title: "News feed", image: UIImage(named: "tab_bar_item_news_feed"), tag: 0)
        let navC1 = putInNavigationController(vc1)
        
        let vc2 = TimetableViewController()
        vc2.tabBarItem = UITabBarItem(title: "Timetable", image: UIImage(named: "tab_bar_item_timetable"), tag: 1)
        let navC2 = putInNavigationController(vc2)
        
        let vc3 = UIViewController()
        vc3.title = "In progress"
        vc3.view.backgroundColor = .white
        vc3.tabBarItem = UITabBarItem(title: "Settings", image: UIImage(named: "tab_bar_item_settings"), tag: 2)
        let navC3 = putInNavigationController(vc3)
        
        tabBarController.viewControllers = [navC1, navC2, navC3]
        tabBarController.selectedIndex = 1
        
        return tabBarController
    }
    
    public static func putInNavigationController(_ vc: UIViewController) -> UINavigationController {
        let navigationController = UINavigationController(rootViewController: vc)
        return navigationController
    }
}
