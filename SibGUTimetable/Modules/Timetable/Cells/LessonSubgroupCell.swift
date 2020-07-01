//
//  LessonSubgroupCell.swift
//  SibGUTimetable
//
//  Created by Александр Камышев on 09.03.2020.
//  Copyright © 2020 Alexandr. All rights reserved.
//

import Foundation

import UIKit

class LessonSubgroupCell: UITableViewCell {
    
    var cells: [LessonCell] = []

    var lessonViewModels: [TimetableLessonViewModel] = [] {
        didSet {
            cells.forEach { (view) in
                view.removeFromSuperview()
            }
            cells.removeAll()
            setupCell()
        }
    }
    
    func setupCell() {
        for i in 0..<lessonViewModels.count {
            let view = LessonCell()
            view.translatesAutoresizingMaskIntoConstraints = false
            view.viewModel = lessonViewModels[i]
            cells.append(view)
            contentView.addSubview(view)
        }
    }
    
    
    
    override func layoutSubviews() {
        super.layoutSubviews()

        let height = contentView.bounds.height
        let width = contentView.bounds.width
        
        var y = contentView.frame.origin.y
        
        for cell in cells {
            cell.setNeedsLayout()
            cell.layoutIfNeeded()
            cell.sizeToFit()
            
            logger.debug("cell frame = \(cell.contentView)")
            //TODO: calculate overall height of cell through sum of all labels and margins
            cell.frame = .init(x: 0, y: y, width: width, height: 100)
            cell.frame.origin.y = y
            y += cell.bounds.height
        }
//        frame.size.height = CGFloat(300)
//        contentView.frame.size.height = CGFloat(300)
        
        frame.size.height = CGFloat(y)
        contentView.frame.size.height = CGFloat(y)
    }
    
}

