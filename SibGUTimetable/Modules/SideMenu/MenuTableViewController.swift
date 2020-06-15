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
    
    private struct HeaderViewParameters {
        static let height: Int = 100
    }
    
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
        let header = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: HeaderViewParameters.height))
        
        let title = UILabel()
        title.translatesAutoresizingMaskIntoConstraints = false
        title.text = "SibGU Timetable"
        title.font = UIFont.systemFont(ofSize: 28)
        title.textAlignment = .center
        
        header.addSubview(title)
        NSLayoutConstraint.activate([
            title.leadingAnchor.constraint(equalTo: header.leadingAnchor),
            title.trailingAnchor.constraint(equalTo: header.trailingAnchor),
            title.topAnchor.constraint(equalTo: header.topAnchor),
            title.bottomAnchor.constraint(equalTo: header.bottomAnchor),
        ])
        
        return header
    }()
    
    override func viewDidLoad() {
        view.addSubview(tableView)
        let leadingMargin = view.frame.width - SideMenuController.preferences.basic.menuWidth
        let topAnchor = view.layoutMarginsGuide.topAnchor
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: leadingMargin + view.layoutMargins.left),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
        
        //TODO: make more gray
        view.backgroundColor = ThemeProvider.shared.whiteBackgroundColor
        tableView.backgroundColor = ThemeProvider.shared.whiteBackgroundColor
        
    }
    
}
