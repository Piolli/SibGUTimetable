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
    private let timetableDataManager: TimetableDataManager
    
    var isFirstAppOpening: Bool {
        let preferences: UserPreferences = Assembler.shared.resolve()
        let isOpening = preferences.isFirstAppOpening()
        logger.debug("isOpening: \(isOpening)")
        preferences.setFirstAppOpening()
        return isOpening
    }
    
    lazy var sideCoordinator = SideMenuCoordinator(mainCoordinator: TimetableCoordinator(navigationController: nil, timetableDataManager: timetableDataManager), menuSections: [
        ///Observe for teachers and their lessons
        (LocalizedStrings.Change_group, GroupSearchCoordinator(appCoordinator: self, dataManager: timetableDataManager)),
        (LocalizedStrings.Settings, SimpleCoordinator()),
        (LocalizedStrings.About_app, AboutAppCoordinator(aboutItems: [
            (LocalizedStrings.Feedback, SimpleCoordinator(FeedbackViewController())),
            (LocalizedStrings.Rate_Me, SimpleCoordinator()),
            (LocalizedStrings.Licenses, SimpleCoordinator(AcknowListViewController())),
        ]))
    ])
    
    lazy var onboardingCoordinator = OnboardingCoordinator()
    
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
        self.timetableDataManager = Assembler.shared.resolve()
        self.window = window
        self.navigationController = UINavigationController()
    }
    
    func showOnboardingScreen() {
        guard let rootViewController = window.rootViewController else {
            fatalError("First set up window.rootViewController")
        }
        onboardingCoordinator.start()
        rootViewController.present(onboardingCoordinator.rootViewController, animated: true, completion: nil)
    }

    func start() {
        window.rootViewController = rootViewController
        rootCoordinator.start()
        window.makeKeyAndVisible()
        if isFirstAppOpening {
            showOnboardingScreen()
        }
    }
    
}
