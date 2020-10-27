//
//  UIView + Ext.swift
//  SibGUTimetable
//
//  Created by Александр Камышев on 27.10.2020.
//  Copyright © 2020 Alexandr. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    class func exerciseAmbiguity(_ view: UIView) {
        #if DEBUG
        if view.hasAmbiguousLayout {
            Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { _ in
                view.exerciseAmbiguityInLayout()
                logger.debug("Debug layout")
            }
        } else {
            for subview in view.subviews {
                UIView.exerciseAmbiguity(subview)
                logger.debug("Debug layout")
            }
        }
        #endif
    }
}
