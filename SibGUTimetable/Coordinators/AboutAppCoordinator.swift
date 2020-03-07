//
//  AboutAppCoordinator.swift
//  SibGUTimetable
//
//  Created by Александр Камышев on 07.03.2020.
//  Copyright © 2020 Alexandr. All rights reserved.
//

import Foundation
import UIKit

class AboutAppCoordinator : Coordinator {
    
    typealias Item = (itemName: String, coordinator: Coordinator)
    
    let aboutItems: [Item]
    let aboutAppViewController: AboutAppViewController
    
    var rootViewController: UIViewController {
        return aboutAppViewController
    }
    
    init(aboutItems: [Item]) {
        self.aboutItems = aboutItems
        aboutAppViewController = AboutAppViewController()
        aboutAppViewController.coordinator = self
    }
    
    func start() {
        aboutAppViewController.items = aboutItems.map( { $0.itemName } )
    }
    
    func didSelectMenuSection(itemName: String) {
        if let item = aboutItems.filter({$0.itemName == itemName}).first {
            push(item: item)
        } else {
            //log
            print("Item with name '\(itemName)' don't exist or select default coordinator")
        }
    }
    
    private func push(item: Item) {
        //TODO: check out memory leaks
        item.coordinator.start()
        rootViewController.navigationController?.pushViewController(item.coordinator.rootViewController, animated: true)
    }
}
