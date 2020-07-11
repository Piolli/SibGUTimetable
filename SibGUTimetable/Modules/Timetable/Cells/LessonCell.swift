//
//  LessonCell.swift
//  SibGUTimetable
//
//  Created by Александр Камышев on 21.02.2020.
//  Copyright © 2020 Alexandr. All rights reserved.
//

import Foundation

import UIKit

class LessonCell: UITableViewCell {
    
    var viewModel: TimetableLessonViewModel? {
        didSet {
            nameLabel.text = self.viewModel?.lessonName
            timeRangeLabel.text = self.viewModel?.timeRange
            typeLabel.text = self.viewModel?.typeLesson
            teacherLabel.text = self.viewModel?.teacher
            officeLabel.text = self.viewModel?.office
        }
    }

    private let timeRangeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = .preferredFont(forTextStyle: .callout)
        label.textColor = ThemeProvider.shared.labelColor
        label.text = "8:00\n9:30"
        return label
    }()
    
    private let officeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Л318"
        label.numberOfLines = 0
        label.textColor = ThemeProvider.shared.labelColor
        label.font = .preferredFont(forTextStyle: .caption1)
        return label
    }()
    
    private let typeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Лабораторная работа"
        label.numberOfLines = 0
        label.font = .preferredFont(forTextStyle: .caption1)
        label.textColor = ThemeProvider.shared.labelColor
        label.textAlignment = .right
        return label
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.setContentCompressionResistancePriority(UILayoutPriority(751), for: .vertical)
        label.setContentHuggingPriority(UILayoutPriority(249), for: .vertical)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = .preferredFont(forTextStyle: .headline)
        label.textColor = ThemeProvider.shared.labelColor
        label.text = "Разработка корпоративных приложений"
        return label
    }()
    
    private let teacherLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Зотин А. Г."
        label.numberOfLines = 0
        label.textColor = ThemeProvider.shared.linkColor
        label.font = .preferredFont(forTextStyle: .caption1)
        return label
    }()
    
    private let separatorView: UIView = {
        let separatorView = UIView()
        separatorView.translatesAutoresizingMaskIntoConstraints = false
        separatorView.backgroundColor = ThemeProvider.shared.separatorColor
        return separatorView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupCell()
    }
}

extension LessonCell {
    
    public func hideTimeRangeLabel() {
        timeRangeLabel.isHidden = true
    }
    
    fileprivate func constraintSeparatorView(_ margins: UILayoutGuide) {
        let additionalWidthForTimeLabel = CGFloat(16)
        NSLayoutConstraint.activate([
            separatorView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            separatorView.leadingAnchor.constraint(equalTo: margins.leadingAnchor, constant: contentView.frame.height + additionalWidthForTimeLabel),
            separatorView.widthAnchor.constraint(equalToConstant: 1),
            separatorView.heightAnchor.constraint(equalTo: contentView.heightAnchor)
        ])
    }
    
    fileprivate func constraintTimeRangeLabel(_ margins: UILayoutGuide, _ marginsValues: UIEdgeInsets) {
        NSLayoutConstraint.activate([
            timeRangeLabel.leadingAnchor.constraint(equalTo: margins.leadingAnchor),
            timeRangeLabel.trailingAnchor.constraint(equalTo: separatorView.leadingAnchor, constant: -(marginsValues.right)),
            timeRangeLabel.topAnchor.constraint(equalTo: margins.topAnchor),
            timeRangeLabel.bottomAnchor.constraint(equalTo: margins.bottomAnchor),
        ])
    }
    
    func setupCell() {
        
        contentView.backgroundColor = ThemeProvider.shared.lessonCellBackgroungColor
        
        contentView.addSubview(separatorView)
        contentView.addSubview(timeRangeLabel)
        contentView.addSubview(officeLabel)
        contentView.addSubview(typeLabel)
        contentView.addSubview(nameLabel)
        contentView.addSubview(teacherLabel)
        
        let margins = contentView.layoutMarginsGuide
        let marginsValues = contentView.layoutMargins
        
        #if DEBUG
        if false {
            timeRangeLabel.backgroundColor = .green
            officeLabel.backgroundColor = .red
            typeLabel.backgroundColor = .blue
        }
        #endif
        
        //TODO: why leading anchor is to leading instead of trailing of separator view?
        constraintSeparatorView(margins)
        constraintTimeRangeLabel(margins, marginsValues)

        let separatorMargins = separatorView.layoutMarginsGuide
        NSLayoutConstraint.activate([
            officeLabel.leadingAnchor.constraint(equalTo: separatorMargins.leadingAnchor),
            officeLabel.topAnchor.constraint(equalTo: margins.topAnchor)
        ])
            
        NSLayoutConstraint.activate([
            typeLabel.trailingAnchor.constraint(equalTo: margins.trailingAnchor),
            typeLabel.topAnchor.constraint(equalTo: margins.topAnchor),
            typeLabel.leadingAnchor.constraint(equalTo: officeLabel.trailingAnchor, constant: 8),
            typeLabel.widthAnchor.constraint(equalTo: officeLabel.widthAnchor)
        ])
        
        //Add lesson name
        let optionalTopAnchorConstraint = nameLabel.topAnchor.constraint(equalTo: margins.topAnchor)
        optionalTopAnchorConstraint.priority = .defaultLow
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(greaterThanOrEqualToSystemSpacingBelow: officeLabel.bottomAnchor, multiplier: 1.0),
            nameLabel.topAnchor.constraint(greaterThanOrEqualToSystemSpacingBelow: typeLabel.bottomAnchor, multiplier: 1.0),
            nameLabel.leadingAnchor.constraint(equalTo: separatorMargins.leadingAnchor),
            nameLabel.trailingAnchor.constraint(equalTo: margins.trailingAnchor),
            optionalTopAnchorConstraint
        ])

        //add teacher
        NSLayoutConstraint.activate([
            teacherLabel.topAnchor.constraint(equalToSystemSpacingBelow: nameLabel.bottomAnchor, multiplier: 1.0),
            teacherLabel.leadingAnchor.constraint(equalTo: separatorMargins.leadingAnchor),
            teacherLabel.trailingAnchor.constraint(equalTo: margins.trailingAnchor),
            teacherLabel.bottomAnchor.constraint(equalTo: margins.bottomAnchor),
        ])
        
    }
    
}
