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
            cell.frame.origin.y = y
            let autoLayoutHeight = cell.systemLayoutSizeFitting(CGSize(width: bounds.width, height: UIView.layoutFittingCompressedSize.height))
            cell.frame.size.height = autoLayoutHeight.height
            cell.frame.size.width = bounds.width
            logger.info("Calculated height: \(autoLayoutHeight)")
            y += cell.frame.height
        }
        
        logger.debug("Full Height of Cell: \(y)")
        frame.size.height = CGFloat(y)
        contentView.frame.size.height = CGFloat(y)
    }
    
}

