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
    
    typealias MenuSection = (sectionName: String, coordinator: Coordinator)
    typealias MenuSections = [MenuSection]
    
    let sideMenuController: SideMenuController
    
    var rootViewController: UIViewController {
        return sideMenuController
    }
    
    let rootContentNavigatonController: UINavigationController
    let menuListCoordinator: MenuListCoordinator
    let menuSections: MenuSections
    
    ///Default Coordinator's rootViewController is added to UINavigationController
    ///Then UINavigationController is used for pushing another UIViewControllers
    init(mainCoordinator: Coordinator, menuSections: MenuSections) {
        self.menuSections = menuSections
        
        rootContentNavigatonController = UINavigationController.createAndPush(mainCoordinator.rootViewController)
        menuListCoordinator = MenuListCoordinator(menuSections: menuSections.map({ $0.sectionName }))
        sideMenuController = SideMenuController(contentViewController: rootContentNavigatonController,
                                                menuViewController: menuListCoordinator.rootViewController)

        menuListCoordinator.coordinator = self
        sideMenuController.navigationItem.title = "SideMenuController"
        setupSideMenuControllerPreferences()
    }

    func setupSideMenuControllerPreferences() {
        SideMenuController.preferences.basic.enableRubberEffectWhenPanning = false
    }
    
    func start() {
        menuListCoordinator.start()
    }
    
    func didSelectMenuSection(sectionName: String) {
        if let menuSection = menuSections.filter({$0.sectionName == sectionName}).first {
            pushCoordinatorToRootNavigationController(coordinator: menuSection.coordinator)
        } else {
            print("Menu Section with name '\(sectionName)' don't exist or select default coordinator")
        }
    }
    
    private func pushCoordinatorToRootNavigationController(coordinator: Coordinator) {
        sideMenuController.hideMenu()
        coordinator.start()
        rootContentNavigatonController.pushViewController(coordinator.rootViewController, animated: true)
    }

}



class MenuListCoordinator : NSObject, Coordinator, UITableViewDelegate {
    let menuTableViewController: MenuTableViewController
    let dataSource: ReusableTableViewDataSource<String>
    unowned var coordinator: SideMenuCoordinator!
    let menuSections: [String]
    
    init(menuSections: [String]) {
        self.menuSections = menuSections
        
        menuTableViewController = MenuTableViewController()
        dataSource = ReusableTableViewDataSource<String>(models: menuSections, reuseIdentifier: MenuTableViewController.cellIdentifier, cellConfigurator: { (str, cell) in
            cell.textLabel?.text = str
            cell.textLabel?.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        })
        super.init()
        menuTableViewController.tableView.delegate = self
    }
    
    func start() {
        menuTableViewController.tableView.dataSource = dataSource
    }
    
    var rootViewController: UIViewController {
        return menuTableViewController
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        coordinator.didSelectMenuSection(sectionName: menuSections[indexPath.row])
    }
    
}

class SimpleCoordinator : Coordinator {
    func start() {
        
    }
    
    lazy var rootViewController: UIViewController = {
        let vc = ButtonViewController()
        vc.view.backgroundColor = .blue
        return vc
    }()
    
}

class ButtonViewController : UIViewController {

    var coordinator: SideMenuCoordinator!
    let button = UIButton(type: .system)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Work with side menu
         
        navigationItem.title = "ButtonViewController"
        
         button.translatesAutoresizingMaskIntoConstraints = false
         view.addSubview(button)
         button.snp.makeConstraints { (maker) in
            maker.centerX.centerY.equalToSuperview()
         }
         button.addTarget(self, action: #selector(showMenu(_:)), for: .touchUpInside)
         button.setTitle("Show", for: .normal)
     }
    
     @objc func showMenu(_ sender: UIButton) {
//        coordinator.openTimetable()
     }

}
