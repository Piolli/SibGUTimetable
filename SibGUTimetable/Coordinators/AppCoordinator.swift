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
import AcknowList

class AppCoordinator : NSObject, Coordinator {
    
    
    private let window: UIWindow
    private var tabBarController: UITabBarController!
    private var navigationController: UINavigationController
    
    lazy var sideCoordinator = SideMenuCoordinator(mainCoordinator: TimetableCoordinator(navigationController: nil), menuSections: [
        ///Observe for teachers and their lessons
        (LocalizedStrings.Change_group, GroupSearchCoordinator(appCoordinator: self)),
        (LocalizedStrings.Settings, SimpleCoordinator()),
        (LocalizedStrings.About_app, AboutAppCoordinator(aboutItems: [
            (LocalizedStrings.Feedback, SimpleCoordinator()),
            (LocalizedStrings.Rate_Me, SimpleCoordinator()),
            (LocalizedStrings.Licenses, SimpleCoordinator(AcknowListViewController())),
        ]))
    ])
    
    private lazy var rootCoordinator: Coordinator = {
//        return TestPageView(navigationController: self.navigationController)
//        return GroupSearchCoordinator(nav: self.navigationController)
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
    }

    func start() {
        window.rootViewController = rootViewController
        rootCoordinator.start()
        window.makeKeyAndVisible()
    }
    
}
