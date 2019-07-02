//
//  CalendarHeaderView.swift
//  SibGUTimetable
//
//  Created by Alexandr on 02/07/2019.
//  Copyright © 2019 Alexandr. All rights reserved.
//

import UIKit

class CalendarHeaderView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        baseInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        baseInit()
    }
    
    func baseInit() {
        backgroundColor = .lightGray
        
        let hStack = UIStackView()
        hStack.axis = .horizontal
        hStack.alignment = .center
        hStack.distribution = .fillEqually
        hStack.spacing = 22
        self.addSubview(hStack)
        
        hStack.snp.makeConstraints { (make) in
            make.margins.equalToSuperview()
        }
        
        let leftButton = UIButton(type: .roundedRect)
        let rightButton = UIButton(type: .roundedRect)
        
    
        let roundedRectangle = UIView()
        roundedRectangle.backgroundColor = .darkGray
        roundedRectangle.layer.cornerRadius = 4
        roundedRectangle.snp.makeConstraints { (make) in
            make.height.equalTo(8)
            make.width.equalTo(10)
        }
        
        hStack.addArrangedSubview(leftButton)
        hStack.addArrangedSubview(roundedRectangle)
        hStack.addArrangedSubview(rightButton)
        
        
        rightButton.setTitle("Right", for: .normal)
        rightButton.setTitleColor(.blue, for: .normal)
//        rightButton.backgroundColor = .purple
        
        leftButton.setTitle("Left", for: .normal)
        leftButton.setTitleColor(.blue, for: .normal)
    }

}
