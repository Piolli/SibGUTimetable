//
//  TimetableLessonViewCell.swift
//  SibGUTimetable
//
//  Created by Alexandr on 07/07/2019.
//  Copyright © 2019 Alexandr. All rights reserved.
//

import UIKit

class TTLessonView: UITableViewCell {
    
    var viewModel: TTLessonViewModel? {
        didSet {
            nameLabel.text = self.viewModel?.title
            timeRangeLabel.text = self.viewModel?.timeRange
            typeLabel.text = self.viewModel?.typeLesson
            teacherLabel.text = self.viewModel?.teacher
            officeLabel.text = self.viewModel?.office
        }
    }

    private let timeRangeLabel: UILabel = {
        let label = UILabel()
        label.text = "8:00 – 9:30"
        return label
    }()
    
    private let typeLabel: UILabel = {
        let label = UILabel()
        label.text = "Лабораторная работа"
        return label
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
//        label.font = label.font.withSize(14)
//        label.setContentHuggingPriority(UILayoutPriority(rawValue: 200), for: .horizontal)
        label.numberOfLines = 5
        label.text = "Разработка корпоративных приложений"
        return label
    }()
    
    private let teacherLabel: UILabel = {
        let label = UILabel()
        label.text = "Зотин А. Г."
        return label
    }()
    
    private let officeLabel: UILabel = {
        let label = UILabel()
        label.text = "Л318"
        return label
    }()
    
    
    override func layoutSubviews() {
//        self.contentView.layoutMargins = UIEdgeInsets(top: 16, left: 8, bottom: 16, right: 8)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        
        
        self.contentView.addSubview(timeRangeLabel)
        self.contentView.addSubview(typeLabel)
//        addSubview(nameLabel)
//        addSubview(teacherLabel)
//        addSubview(officeLabel)
        
        timeRangeLabel.snp.makeConstraints { (make) in
            make.leftMargin.topMargin.equalTo(self.contentView)
        }
        
        typeLabel.snp.makeConstraints { (make) in
            make.rightMargin.topMargin.equalTo(self.contentView)
        }
        
        let vStack = UIStackView(arrangedSubviews: [nameLabel, teacherLabel, officeLabel])
//        vStack.setContentCompressionResistancePriority(UILayoutPriority.defaultHigh, for: .vertical)
        self.contentView.addSubview(vStack)
        vStack.axis = .vertical
//        vStack.distribution = .equalSpacing
        vStack.snp.makeConstraints { (make) in
            make.topMargin.equalTo(timeRangeLabel).offset(20)
            make.leftMargin.rightMargin.bottomMargin.equalTo(self.contentView)
        }
 
        
        initAppearance()
    }
    
    func initAppearance() {
        //Parent view
        self.layer.cornerRadius = 8
        self.layer.masksToBounds = true
//        self.layer.shadowColor = UIColor.darkGray.cgColor
//        self.layer.shadowOffset = CGSize(width: 1, height: -1)

//        //INNER VIEW
//        self.contentView.layer.shadowColor = UIColor.darkGray.cgColor
//        self.contentView.layer.shadowRadius = 4
//        self.contentView.layer.shadowOpacity = 0.5
//        self.contentView.layer.shadowOffset = CGSize(width: 0, height: 0)
//        self.contentView.layer.shadowPath = UIBezierPath(roundedRect: self.contentView.frame, byRoundingCorners: .allCorners, cornerRadii: CGSize(width: 4, height: 4)).cgPath
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

}
