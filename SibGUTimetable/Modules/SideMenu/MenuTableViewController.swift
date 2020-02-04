//
//  MenuTableViewController.swift
//  SibGUTimetable
//
//  Created by Александр Камышев on 02.02.2020.
//  Copyright © 2020 Alexandr. All rights reserved.
//

import Foundation
import SideMenuSwift
import UIKit

class MenuTableViewController : UIViewController {
    
    public static let cellIdentifier = "cell"
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        tableView.tableHeaderView = headerView
        tableView.isScrollEnabled = false
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
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
        view.addSubview(tableView)
        let leadingMargin = view.frame.width - SideMenuController.preferences.basic.menuWidth
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: leadingMargin + view.layoutMargins.left),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
}
