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
    var separators: [UIView] = []
    
    public let timeRangeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = .preferredFont(forTextStyle: .callout)
        label.textColor = ThemeProvider.shared.labelColor
        label.text = "08:00\n09:30"
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupCell()
    }
    
    func setupCell() {
        contentView.backgroundColor = ThemeProvider.shared.lessonCellBackgroungColor
        contentView.addSubview(timeRangeLabel)
    }

    var lessonViewModels: [TimetableLessonViewModel] = [] {
        didSet {
            cells.forEach { (view) in
                view.removeFromSuperview()
            }
            separators.forEach { (separator) in
                separator.removeFromSuperview()
            }
            separators.removeAll()
            cells.removeAll()
            setupCellLayout()
        }
    }
    
    func setupCellLayout() {
        for i in 0..<lessonViewModels.count {
            let view = LessonCell()
            view.translatesAutoresizingMaskIntoConstraints = false
            view.viewModel = lessonViewModels[i]
            view.hideTimeRangeLabel()
            if i < lessonViewModels.count - 1 {
                let separator = UIView()
                separator.translatesAutoresizingMaskIntoConstraints = false
                separator.backgroundColor = ThemeProvider.shared.lightSeparatorColor
                separators.append(separator)
                contentView.addSubview(separator)
            }
            cells.append(view)
            contentView.addSubview(view)
        }
        contentView.bringSubviewToFront(timeRangeLabel)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        var y = contentView.frame.origin.y
        
        for (i, cell) in cells.enumerated() {
            cell.frame.origin.y = y
            let autoLayoutHeight = cell.systemLayoutSizeFitting(CGSize(width: bounds.width, height: UIView.layoutFittingCompressedSize.height))
            cell.frame.size.height = autoLayoutHeight.height
            cell.frame.size.width = bounds.width
            if i < separators.count {
                separators[i].frame = .init(x: cell.separatorOriginX, y: cell.frame.maxY, width: cell.bounds.width - cell.separatorOriginX, height: 1)
            }
            logger.trace("Calculated height: \(autoLayoutHeight)")
            y += cell.frame.height + 1
        }
        
        logger.trace("Full Height of Cell: \(y)")
        frame.size.height = CGFloat(y)
        contentView.frame.size.height = CGFloat(y)
        
        if let cellTimeRangeFrame = cells.first?.timeRangeLabelFrame {
            ///The same x, y and width values
            timeRangeLabel.frame = cellTimeRangeFrame
            ///Set different height
            timeRangeLabel.frame.size.height = contentView.frame.size.height - cellTimeRangeFrame.origin.y * 2
            timeRangeLabel.text = cells.first!.viewModel?.timeRange
        }
        logger.trace("timeRangeLabel.frame = \(timeRangeLabel.frame)| BOUNDS: \(contentView.bounds)")
        
    }
    
}

