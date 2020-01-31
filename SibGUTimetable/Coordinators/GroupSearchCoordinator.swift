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
    
    weak var navigationController: UINavigationController!
    
    var rootViewController: UIViewController {
        return navigationController
    }

    init(nav: UINavigationController) {
        navigationController = nav
        let ttViewController = GroupSearchViewController()
        ttViewController.apiServer = NativeAPIServer.sharedInstance
        ttViewController.coordinator = self
        nav.pushViewController(ttViewController, animated: true)
//        navigationController = AppCoordinator.putInNavigationController(ttViewController)
    }
    
    #if DEBUG
    func openSearchedGroup(pair: PairIDName) {
        let ttVC = TabTTPageViewCoordinator(navigationController: navigationController)
//        navigationController.pushViewController((ttVC.rootViewController as! UINavigationController).viewControllers[0], animated: true)
        //ONLY FOR DEBUG
        NativeAPIServer.sharedInstance.fetchTimetable(groupId: pair.id, groupName: pair.name)
            .observeOn(MainScheduler.instance)
            .subscribe(onSuccess: { (timetable) in
            ttVC.startWith(timetable: timetable)
        }) { (error) in
            fatalError(error.localizedDescription)
        }
    }
    #endif
    
    func start() {
//        let controller = TTPageViewController()
//        navigationController?.pushViewController(controller, animated: true)
    }
    
}
