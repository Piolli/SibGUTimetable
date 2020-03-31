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

    var lessonViewModels: [TimetableLessonViewModel] = [] {
        didSet {
            setupCell()
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
//        setupCell()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
//        setupCell()
    }
    
    func setupCell() {
        var cells: [SubLessonContentView] = []
        
        //make view with vertical spacing items. calculate height of each others
        
        
        for i in 0..<lessonViewModels.count {
            let view = SubLessonContentView()
            contentView.addSubview(view)
            view.translatesAutoresizingMaskIntoConstraints = false
            view.viewModel = lessonViewModels[i]
            cells.append(view)
        }
        
        contentView.backgroundColor = .red
        
        
//        let stackView = UIStackView(arrangedSubviews: cells)
//        stackView.translatesAutoresizingMaskIntoConstraints = false
//        stackView.axis = .vertical
//        stackView.distribution = .equalSpacing
//        stackView.spacing = UIStackView.spacingUseSystem
//        contentView.addSubview(stackView)
        
//        NSLayoutConstraint.activate([
//            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
//            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
//            stackView.topAnchor.constraint(equalTo: contentView.topAnchor),
//            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
//        ])
        
        if lessonViewModels.count == 0 {
            return
        }
        
        let firstCell = cells[0]
        
        NSLayoutConstraint.activate([
            firstCell.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            firstCell.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            firstCell.topAnchor.constraint(equalTo: contentView.topAnchor)
        ])
        
        let lastCell = cells.last!
        
        NSLayoutConstraint.activate([
            lastCell.topAnchor.constraint(equalTo: cells[cells.count-2].bottomAnchor),
            lastCell.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            lastCell.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            lastCell.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        
        for i in 1..<cells.count-1 {
            NSLayoutConstraint.activate([
                cells[i].topAnchor.constraint(equalTo: cells[i-1].bottomAnchor),
                cells[i].leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
                cells[i].trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
            ])
        }
        
        
        
    }
    
}

class SubLessonContentView: UITableViewCell {
    
    var viewModel: TimetableLessonViewModel? {
        didSet {
            nameLabel.text = self.viewModel?.lessonName
            typeLabel.text = self.viewModel?.typeLesson
            teacherLabel.text = self.viewModel?.teacher
            officeLabel.text = self.viewModel?.office
        }
    }
    
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
        if #available(iOS 13, *) {
            label.textColor = .systemTeal }
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
    
    private let subGroupLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "* подгруппа"
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 12)
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
}

extension SubLessonContentView {
    
    func setupCell() {
    
        contentView.addSubview(officeLabel)
        contentView.addSubview(typeLabel)
//        contentView.addSubview(nameLabel)
//        contentView.addSubview(teacherLabel)
//        contentView.addSubview(subGroupLabel)
        
        let margins = contentView.layoutMarginsGuide
        let marginsValues = contentView.layoutMargins
        
        if true {
            officeLabel.backgroundColor = .red
            typeLabel.backgroundColor = .blue
        }

        //width
        NSLayoutConstraint.activate([
            officeLabel.leadingAnchor.constraint(equalTo: margins.leadingAnchor),
            officeLabel.topAnchor.constraint(equalTo: margins.topAnchor),
            officeLabel.widthAnchor.constraint(equalToConstant: 100)
        ])
            
        //width and horizontal
        typeLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        NSLayoutConstraint.activate([
            typeLabel.trailingAnchor.constraint(equalTo: margins.trailingAnchor),
            typeLabel.topAnchor.constraint(equalTo: margins.topAnchor),
            typeLabel.leadingAnchor.constraint(equalTo: officeLabel.trailingAnchor, constant: 8)
        ])
        
//        //Add lesson name
//        let optionalTopAnchorConstraint = nameLabel.topAnchor.constraint(equalTo: margins.topAnchor)
//        optionalTopAnchorConstraint.priority = .defaultLow
//        NSLayoutConstraint.activate([
//            nameLabel.topAnchor.constraint(greaterThanOrEqualToSystemSpacingBelow: officeLabel.bottomAnchor, multiplier: 1.0),
//            nameLabel.topAnchor.constraint(greaterThanOrEqualToSystemSpacingBelow: typeLabel.bottomAnchor, multiplier: 1.0),
//            nameLabel.leadingAnchor.constraint(equalTo: margins.leadingAnchor),
//            nameLabel.trailingAnchor.constraint(equalTo: margins.trailingAnchor),
//            optionalTopAnchorConstraint
//        ])
//
//        //add teacher
//        NSLayoutConstraint.activate([
//            teacherLabel.topAnchor.constraint(equalToSystemSpacingBelow: nameLabel.bottomAnchor, multiplier: 1.0),
//            teacherLabel.leadingAnchor.constraint(equalTo: margins.leadingAnchor),
//            teacherLabel.trailingAnchor.constraint(equalTo: margins.trailingAnchor),
//            teacherLabel.bottomAnchor.constraint(equalTo: margins.bottomAnchor),
//        ])
    }
    
}

