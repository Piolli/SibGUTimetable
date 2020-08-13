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
    
    var calendarViewSelectedMonthDaysTextColor: UIColor { get }
    
    var linkColor: UIColor { get }
    
    var lessonCellBackgroungColor: UIColor { get }
    
    var calendarViewBackgroungColor: UIColor { get }
    
    var calendarViewMonthTitleTextColor: UIColor { get }
    
    var calendarViewWeekdayTextColor: UIColor { get }
    
    var calendarPrevAndNextMonthDaysTextColor: UIColor { get }
    
    var separatorColor: UIColor { get }
    
    var lightSeparatorColor: UIColor { get }
    
    var labelColor: UIColor { get }
    
    var secondaryLabelColor: UIColor { get }
    
}

extension Theme {
    
    var labelColor: UIColor {
        if #available(iOS 13.0, *) {
            return UIColor.label
        }
        else {
            //label in light mode
            return .init(rgb: 0x000000)
        }
    }
    
    var secondaryLabelColor: UIColor {
        if #available(iOS 13.0, *) {
            return UIColor.secondaryLabel
        }
        else {
            //secondaryLabel in light mode
            return UIColor.init(rgb: 0x3c3c43).withAlphaComponent(0.6)
        }
    }
    
    var lightSeparatorColor: UIColor {
        return .init(
            light: UIColor(red: 237/255, green: 237/255, blue: 237/255, alpha: 1),
            dark: UIColor(red: 32/255, green: 32/255, blue: 32/255, alpha: 1))
    }
    
    var separatorColor: UIColor {
        return .init(
            light: UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 1),
            dark: UIColor(red: 60/255, green: 60/255, blue: 60/255, alpha: 1))
    }
    
    var calendarPrevAndNextMonthDaysTextColor: UIColor {
        return .init(light: .init(white: 0.60, alpha: 1), dark: .init(white: 0.40, alpha: 1))
    }
    
    var calendarViewMonthTitleTextColor: UIColor {
        if #available(iOS 13.0, *) {
            return UIColor.systemGray
        }
        else {
            //systemGray in light mode
            return .init(rgb: 0x8e8e93)
        }
    }
    
    var calendarViewWeekdayTextColor: UIColor {
        if #available(iOS 13.0, *) {
            return UIColor.systemGray2
        }
        else {
            //systemGray2 in light mode
            return .init(rgb: 0xaeaeb2)
        }
    }
    
    var calendarViewBackgroungColor: UIColor {
        if #available(iOS 13.0, *) {
            return UIColor.systemGray5
        }
        else {
            //systemGray5 in light mode
            return .init(rgb: 0xe5e5ea)
        }
    }
    
    var lessonCellBackgroungColor: UIColor {
        if #available(iOS 13.0, *) {
            return UIColor.systemGray6
        }
        else {
            //systemGray6 in light mode
            return .init(rgb: 0xf2f2f7)
        }
    }
    
    var tableViewBackgroundColor: UIColor {
        if #available(iOS 13.0, *) {
            return UIColor.systemGray6
        }
        else {
            //systemGray6 in light mode
            return .init(rgb: 0xf2f2f7)
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
            return UIColor.systemGray6
        }
        else {
            //systemGray6 in light mode
            return .init(rgb: 0xf2f2f7)
        }
    }
    
    var aboutAppTableViewCellBackgroundColor: UIColor {
        return .init(light: UIColor.init(white: 0.95, alpha: 1), dark: UIColor.init(white: 0.25, alpha: 1))
    }
    
    var calendarViewSelectedMonthDaysTextColor: UIColor {
        return .init(light: .init(white: 0.15, alpha: 1), dark: .init(white: 0.95, alpha: 1))
    }
    
    var linkColor: UIColor {
        if #available(iOS 13.0, *) {
            return UIColor.link
        }
        else {
            return UIColor.blue
        }
    }
    
}

class ThemeProvider : Theme {
    
    static let shared = ThemeProvider()
    
    private init() { }
    
}
