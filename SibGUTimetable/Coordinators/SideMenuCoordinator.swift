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
    
    let menuCoordinator: MenuListCoordinator
    let contentCoordinator: Coordinator
    
    init(contentCoordinator: Coordinator) {
        self.contentCoordinator = contentCoordinator
        
        menuCoordinator = MenuListCoordinator()
        
        sideMenuController = SideMenuController(
            contentViewController: UINavigationController.createAndPush(contentCoordinator.rootViewController),
            menuViewController: menuCoordinator.rootViewController
        )
        SideMenuController.preferences.basic.enableRubberEffectWhenPanning = false
        

        sideMenuController.navigationItem.title = "SideMenuController"
    }

    
    func start() {
        menuCoordinator.start()
        contentCoordinator.start()
    }
    
    func openTimetable() {
        sideMenuController.hideMenu()
        let vc = SimpleCoordinator().rootViewController
//        vc.modalPresentationStyle = .formSheet
//        navigationController.present(vc, animated: true, completion: nil)
//        navigationController.pushViewController(vc, animated: true)
        let nav = (sideMenuController.contentViewController as! UINavigationController)
        nav.pushViewController(SimpleCoordinator().rootViewController, animated: true)
    }
    
}

class MenuTableViewController : UIViewController {
    
    let tableView = UITableView()
    lazy var dataSource: ReusableTableViewDataSource<String> = {
        let dataSource = ReusableTableViewDataSource<String>(models: ["Timetable", "Setting", "About app"], reuseIdentifier: "cell", cellConfigurator: { (str, cell) in
            print("INCELL")
            cell.textLabel?.text = str
            cell.detailTextLabel?.text = str
        })
        return dataSource
    }()
    
    lazy var headerView: UIView = {
        //Move to struct options
        let heightOfHeaderView = 150
        let header = UIView(frame: CGRect(x: 0, y: 0, width: 1, height: heightOfHeaderView))
        let title = UILabel()
        
        title.translatesAutoresizingMaskIntoConstraints = false
        title.text = "SibGU Timetable"
        title.font = UIFont.systemFont(ofSize: 28)
        header.addSubview(title)
        NSLayoutConstraint.activate([
            title.centerXAnchor.constraint(equalTo: header.centerXAnchor),
            title.centerYAnchor.constraint(equalTo: header.centerYAnchor),
        ])
        
        return header
    }()
    
    override func viewDidLoad() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        
        let leadingMargin = view.frame.width - SideMenuController.preferences.basic.menuWidth
        
        tableView.separatorStyle = .none
        tableView.tableHeaderView = headerView
        
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: leadingMargin),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.dataSource = dataSource
    }
    
}


class MenuListCoordinator : NSObject, Coordinator, UITableViewDelegate {
    let menuTableView: MenuTableViewController
    
    override init() {
        menuTableView = MenuTableViewController()
    }
    
    func start() {
        
    }
    
    var rootViewController: UIViewController {
        return menuTableView
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
        coordinator.openTimetable()
     }

}
