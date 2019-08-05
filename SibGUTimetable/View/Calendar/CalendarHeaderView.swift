//
//  CalendarHeaderView.swift
//  SibGUTimetable
//
//  Created by Alexandr on 02/07/2019.
//  Copyright © 2019 Alexandr. All rights reserved.
//

import UIKit

class CalendarHeaderView: UIView {
    
    let previousMonthButton: UIButton = {
        let button = UIButton(type: .roundedRect)
        
        #warning("ONLY DEBUG")
        button.setTitle("<<<", for: .normal)
        
        return button
    }()
    

    let nextMonthButton: UIButton = {
        let button = UIButton(type: .roundedRect)
        
        #warning("ONLY DEBUG")
        button.setTitle(">>>", for: .normal)
        
        return button
    }()
    
    let selectedMonthLabel: UILabel = {
        let label = UILabel()
        #warning("ONLY DEBUG")
        label.text = "October"
        label.font = label.font.withSize(20)
        return label
    }()
    
    let roundedRectangleView: UIView = {
        let roundedRectangle = UIView()
        roundedRectangle.backgroundColor = .darkGray
        roundedRectangle.layer.cornerRadius = 4
        roundedRectangle.snp.makeConstraints { (make) in
            make.height.equalTo(8)
            make.width.equalTo(10)
        }
        return roundedRectangle
    }()
    
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
        
        //Contains [previousMonthButton] [selectedMonthLabel] [nextMonthButton]
        let hStack = UIStackView()
        hStack.axis = .horizontal
        hStack.alignment = .center
        hStack.distribution = .fillProportionally
        hStack.spacing = 22
        
        hStack.addArrangedSubview(previousMonthButton)
        hStack.addArrangedSubview(selectedMonthLabel)
        hStack.addArrangedSubview(nextMonthButton)

//        self.addSubview(hStack)
//        hStack.snp.makeConstraints { (make) in
//            make.margins.equalToSuperview()
//        }
        
        //Contains [roundedView] [hStack]
        let vStack = UIStackView()
        vStack.axis = .vertical
        vStack.alignment = .center
        vStack.distribution = .equalCentering
        vStack.spacing = 10
        
        self.addSubview(vStack)
        vStack.snp.makeConstraints { (make) in
            make.margins.equalToSuperview()
        }
        
        vStack.addArrangedSubview(roundedRectangleView)
        vStack.addArrangedSubview(hStack)
        
//        hStack.addArrangedSubview(previousMonthButton)
//        hStack.addArrangedSubview(vStack)
//        hStack.addArrangedSubview(nextMonthButton)
    }

}
