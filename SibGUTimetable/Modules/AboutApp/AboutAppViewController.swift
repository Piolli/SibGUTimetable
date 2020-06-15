//
//  AboutAppViewController.swift
//  SibGUTimetable
//
//  Created by Александр Камышев on 03.03.2020.
//  Copyright © 2020 Alexandr. All rights reserved.
//

import Foundation
import UIKit

class AboutAppViewController : UITableViewController {
    
    private enum HeaderViewMetrics {
        static let height: CGFloat = 250
        static let appIconHeight: CGFloat = 200
    }
    
    let cellIdentifier = "identifier"
    let headerIconName = "test_app_icon"
    var coordinator: AboutAppCoordinator!
    
    var items: [String] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    lazy var headerView: UIView = {
        var iconView: UIView = {
            let image = UIImage(named: "test_app_icon")
            let imageView = UIImageView(image: image)
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.setContentHuggingPriority(.defaultLow, for: .vertical)
            imageView.setContentHuggingPriority(.defaultLow, for: .horizontal)
            imageView.contentMode = .scaleAspectFit
            return imageView
        }()
        
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        let vStackView = UIStackView()
        vStackView.translatesAutoresizingMaskIntoConstraints = false
        vStackView.axis = .vertical
        vStackView.distribution = .equalSpacing
        vStackView.spacing = 4
        vStackView.alignment = .center
        
        let versionLabel = UILabel()
        versionLabel.translatesAutoresizingMaskIntoConstraints = false
        versionLabel.text = "version 5.x.y"
        versionLabel.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
        
        vStackView.addArrangedSubview(iconView)
        vStackView.addArrangedSubview(versionLabel)
        
        containerView.addSubview(vStackView)
        
        NSLayoutConstraint.activate([
            vStackView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            vStackView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            
            iconView.heightAnchor.constraint(equalTo: iconView.widthAnchor, multiplier: 1),
            iconView.widthAnchor.constraint(equalToConstant: HeaderViewMetrics.appIconHeight)
        ])
        
        return containerView
    }()
    
    override func viewDidLoad() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        tableView.tableFooterView = UIView()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return headerView
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 250
    }
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        NSLayoutConstraint.activate([
            view.widthAnchor.constraint(equalToConstant: view.bounds.width),
            view.heightAnchor.constraint(equalToConstant: HeaderViewMetrics.height)
        ])
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        cell.textLabel?.text = items[indexPath.row]
        cell.accessoryType = .disclosureIndicator
        cell.backgroundColor = ThemeProvider.shared.aboutAppTableViewCellBackgroundColor
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        coordinator.didSelectMenuSection(itemName: items[indexPath.row])
    }
    
}
