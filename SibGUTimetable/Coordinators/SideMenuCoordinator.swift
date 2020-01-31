//
//  SideMenuCoordinator.swift
//  SibGUTimetable
//
//  Created by Александр Камышев on 31.01.2020.
//  Copyright © 2020 Alexandr. All rights reserved.
//

import Foundation
import SideMenuSwift
import UIKit

class SideMenuCoordinator : Coordinator {
    
    let sideMenuController: SideMenuController
    
    var rootViewController: UIViewController {
        return sideMenuController
    }
    
    init(contentViewControllerCoordinator: Coordinator) {
        let vc = UIViewController()
        vc.view.backgroundColor = .red
        
        contentViewControllerCoordinator.start()
        sideMenuController = SideMenuController(contentViewController: contentViewControllerCoordinator.rootViewController, menuViewController: vc)
    }
    
    func start() {
        sideMenuController.revealMenu()
    }
    
}
