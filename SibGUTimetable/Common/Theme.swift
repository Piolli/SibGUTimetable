//
//  Theme.swift
//  SibGUTimetable
//
//  Created by Александр Камышев on 11.06.2020.
//  Copyright © 2020 Alexandr. All rights reserved.
//

import Foundation
import UIKit

public extension UIColor {
    
    convenience init(light: UIColor, dark: UIColor) {
        if #available(iOS 13.0, tvOS 13.0, *) {
            self.init { traitCollection in
                if traitCollection.userInterfaceStyle == .dark {
                    return dark
                }
                return light
            }
        }
        else {
            self.init(cgColor: light.cgColor)
        }
    }
    
}

protocol Theme {
    
    var tableViewBackgroundColor: UIColor { get }

    var titleLabelColor: UIColor { get }
    
    var whiteBackgroundColor: UIColor { get }
    
    var aboutAppTableViewCellBackgroundColor: UIColor { get }
    
    var calendarTitleCellBackgroundColor: UIColor { get }
    
    var linkColor: UIColor { get }
    
}

extension Theme {
    var tableViewBackgroundColor: UIColor {
        if #available(iOS 13.0, *) {
            return UIColor.systemBackground
        }
        else {
            return UIColor.white
        }
    }
    
    var titleLabelColor: UIColor {
        if #available(iOS 13.0, *) {
            return UIColor.label
        }
        else {
            return UIColor.darkGray
        }
    }
    
    var whiteBackgroundColor: UIColor {
        if #available(iOS 13.0, *) {
            return UIColor.systemBackground
        }
        else {
            return UIColor.white
        }
    }
    
    var aboutAppTableViewCellBackgroundColor: UIColor {
        return .init(light: UIColor.init(white: 0.95, alpha: 1), dark: UIColor.init(white: 0.25, alpha: 1))
    }
    
    var calendarTitleCellBackgroundColor: UIColor {
        return .init(light: .init(white: 0.15, alpha: 1), dark: .init(white: 0.95, alpha: 1))
    }
    
    //TODO: Fix link color based on UIColor.link
    var linkColor: UIColor {
        return .init(light: UIColor.blue, dark: UIColor.blue)
    }
    
}

class ThemeProvider : Theme {
    
    static let shared = ThemeProvider()
    
    private init() { }
    
}
