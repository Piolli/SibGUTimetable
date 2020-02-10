//
//  UIViewController + Ext.swift
//  SibGUTimetable
//
//  Created by Александр Камышев on 03.02.2020.
//  Copyright © 2020 Alexandr. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    ///check containerView with constraints and w/o
    func add(viewController: UIViewController, to containerView: UIView) {
        
        viewController.view.translatesAutoresizingMaskIntoConstraints = false
        addChild(viewController)
        containerView.addSubview(viewController.view)
        
        NSLayoutConstraint.activate([
            viewController.view.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            viewController.view.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            viewController.view.topAnchor.constraint(equalTo: containerView.topAnchor),
            viewController.view.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
        ])
        
        viewController.didMove(toParent: self)
    }
    
}
