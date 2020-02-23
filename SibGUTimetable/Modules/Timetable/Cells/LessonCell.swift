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
    
    var viewModel: TTLessonViewModel? {
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
        label.numberOfLines = 2
        label.textAlignment = .center
//        label.adjustsFontSizeToFitWidth = true
        label.font = UIFont.systemFont(ofSize: 15)
        label.text = "8:00\n9:30"
        return label
    }()
    
    private let typeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Лабораторная работа"
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 12)
        label.textAlignment = .right
        return label
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 16)
        label.text = "Разработка корпоративных приложений"
        return label
    }()
    
    private let teacherLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Зотин А. Г."
//        label.textAlignment = .right
        label.font = .systemFont(ofSize: 12)
        return label
    }()
    
    private let officeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Л318"
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 12)
        return label
    }()
    
    private let separatorView: UIView = {
        let separatorView = UIView()
        separatorView.translatesAutoresizingMaskIntoConstraints = false
        separatorView.backgroundColor = UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 1)
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
    
    fileprivate func constraintSeparatorView(_ margins: UILayoutGuide) {
        NSLayoutConstraint.activate([
            separatorView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            separatorView.leadingAnchor.constraint(equalTo: margins.leadingAnchor, constant: contentView.frame.height + 16),
            separatorView.widthAnchor.constraint(equalToConstant: 1),
            separatorView.heightAnchor.constraint(equalTo: contentView.heightAnchor)
        ])
    }
    
    fileprivate func constraintTimeRangeLabel(_ margins: UILayoutGuide, _ marginsValues: UIEdgeInsets) {
        let rootLayoutMargins = layoutMargins
        NSLayoutConstraint.activate([
            timeRangeLabel.leadingAnchor.constraint(equalTo: margins.leadingAnchor),
            timeRangeLabel.trailingAnchor.constraint(equalTo: separatorView.leadingAnchor, constant: -(marginsValues.right )),
            timeRangeLabel.topAnchor.constraint(equalTo: margins.topAnchor),
            timeRangeLabel.bottomAnchor.constraint(equalTo: margins.bottomAnchor),
        ])
    }
    
    func setupCell() {
        #warning("delete this")
        contentView.backgroundColor = UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1)

        contentView.addSubview(separatorView)
        contentView.addSubview(timeRangeLabel)
        contentView.addSubview(officeLabel)
        contentView.addSubview(typeLabel)
        contentView.addSubview(nameLabel)
        contentView.addSubview(teacherLabel)
        
        let margins = contentView.layoutMarginsGuide
        let marginsValues = contentView.layoutMargins
        
        if false {
            timeRangeLabel.backgroundColor = .green
            officeLabel.backgroundColor = .red
            typeLabel.backgroundColor = .blue
        }
        
        //TODO: why leading anchor is to leading instead of trailing of separator view?
        
        constraintSeparatorView(margins)
        constraintTimeRangeLabel(margins, marginsValues)


        let separatorMargins = separatorView.layoutMarginsGuide
        print(separatorView.layoutMargins)
        NSLayoutConstraint.activate([
            officeLabel.leadingAnchor.constraint(equalTo: separatorMargins.leadingAnchor),
            officeLabel.topAnchor.constraint(equalTo: margins.topAnchor)
        ])
            

        print(separatorView.layoutMargins)
        NSLayoutConstraint.activate([
            typeLabel.trailingAnchor.constraint(equalTo: margins.trailingAnchor),
            typeLabel.topAnchor.constraint(equalTo: margins.topAnchor),
            typeLabel.leadingAnchor.constraint(equalTo: officeLabel.trailingAnchor, constant: 8)
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