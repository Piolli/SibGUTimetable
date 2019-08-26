//
//  CalendarDayViewCell.swift
//  SibGUTimetable
//
//  Created by Alexandr on 07/08/2019.
//  Copyright © 2019 Alexandr. All rights reserved.
//

import Foundation
import UIKit

class CalendarDayViewCell : UICollectionViewCell {
    
    let dayNumberLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        return label
    }()
    
    override var isSelected: Bool {
        didSet {
            if self.isSelected {
                contentView.backgroundColor = .red
            } else {
                contentView.backgroundColor = UIColor(red: 0.319, green: 0.561, blue: 0.955, alpha: 1.000)
            }
        }
    }
    
    var isEmpty: Bool = false {
        didSet {
            if self.isEmpty {
                contentView.backgroundColor = .lightGray
                isUserInteractionEnabled = false
                isHidden = true
            }
        }
    }

    
    override func layoutSubviews() {
        
        dayNumberLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(dayNumberLabel)
        dayNumberLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        dayNumberLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        
        contentView.layer.cornerRadius = min(contentView.frame.width, contentView.frame.height) / 2
        
        contentView.backgroundColor = UIColor(red: 0.319, green: 0.561, blue: 0.955, alpha: 1.000)
        
    }
    
}
