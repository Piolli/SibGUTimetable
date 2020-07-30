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
    
    let groupSearchViewController: GroupSearchViewController
    let appCoordinator: AppCoordinator
    
    var rootViewController: UIViewController {
        return groupSearchViewController
    }

    init(appCoordinator: AppCoordinator) {
        self.appCoordinator = appCoordinator
        groupSearchViewController = GroupSearchViewController()
        groupSearchViewController.apiServer = NativeAPIServer.sharedInstance
        groupSearchViewController.coordinator = self
    }
    
//    #if DEBUG
//    func openSearchedGroup(pair: GroupPairIDName) {
//        var navigationController: UINavigationController = .init()
//        let ttVC = TimetableCoordinator(navigationController: navigationController)
////        navigationController.pushViewController((ttVC.rootViewController as! UINavigationController).viewControllers[0], animated: true)
//        //ONLY FOR DEBUG
//        NativeAPIServer.sharedInstance.fetchTimetable(timetableDetails: TimetableDetails(groupId: pair.id, groupName: pair.name))
//            .observeOn(MainScheduler.instance)
//            .subscribe(onSuccess: { (timetable) in
//            ttVC.startWith(timetable: timetable)
//        }) { (error) in
//            fatalError(error.localizedDescription)
//        }
//    }
//    #endif
    
    func start() {
        
//        let controller = TTPageViewController()
//        navigationController?.pushViewController(controller, animated: true)
    }
    
}
