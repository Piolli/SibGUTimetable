//
//  DayOffView.swift
//  SibGUTimetable
//
//  Created by Александр Камышев on 15.09.2020.
//  Copyright © 2020 Alexandr. All rights reserved.
//

import Foundation
import UIKit


class DayOffView: UIView {
    
    private lazy var imageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.image = UIImage(named: "day_off_3")
        view.contentMode = .scaleAspectFit
        view.setContentCompressionResistancePriority(.init(749), for: .vertical)
        view.setContentHuggingPriority(.init(251), for: .vertical)
        return view
    }()
    
    lazy var titleLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.text = LocalizedStrings.Day_off
        view.textAlignment = .center
        //TODO: make autoscaled font
        view.font = .systemFont(ofSize: 22, weight: .semibold)
        view.accessibilityIdentifier = "DayOffTitleLabel"
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(imageView)
        addSubview(titleLabel)
        
        let margins = self
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: margins.topAnchor, constant: 0),
            imageView.centerXAnchor.constraint(equalTo: margins.centerXAnchor),
            imageView.widthAnchor.constraint(equalTo: margins.widthAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: margins.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: margins.trailingAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: margins.bottomAnchor, constant: -8),
        ])
        
    }
    
    func loadImage(from name: String, didLoadImage: @escaping (CGSize) -> Void) {
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let image = UIImage(named: name) else {
                logger.error("Image did not load from local storage")
                return
            }
            DispatchQueue.main.async {
                self?.imageView.image = image
                didLoadImage(image.size)
            }
        }
    }
    
    func debugViews() {
        backgroundColor = .blue
        titleLabel.backgroundColor = .green
        imageView.backgroundColor = .red
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
