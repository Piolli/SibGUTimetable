//
//  UINavigationController + Ext.swift
//  SibGUTimetable
//
//  Created by Александр Камышев on 31.01.2020.
//  Copyright © 2020 Alexandr. All rights reserved.
//

import Foundation
import UIKit

extension UINavigationController {
    
    public static func createAndPush(_ vc: UIViewController) -> UINavigationController {
        let navigationController = UINavigationController(rootViewController: vc)
        return navigationController
    }
    
}
