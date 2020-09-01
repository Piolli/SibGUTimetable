//
//  OnboardingItemViewController.swift
//  SibGUTimetable
//
//  Created by Александр Камышев on 26.08.2020.
//  Copyright © 2020 Alexandr. All rights reserved.
//

import UIKit

class HighButton: UIButton {
    override open var isHighlighted: Bool {
        didSet {
            backgroundColor = isHighlighted ? UIColor.lightGray : UIColor.blue
        }
    }
}

protocol OnboardingItemDelegate: AnyObject {
    func buttomWasTapped(type: OnboardingItemViewController.ActionButtonType)
    func skipButtomWasTapped()
}

class OnboardingItemViewController: UIViewController {

    struct OnboardingItem: Equatable {
        let title: String
        let subtitle: String
        let image: UIImage
        let buttonType: ActionButtonType
    }
    
    enum ActionButtonType {
        case next
        case start
    }
    
    let index: Int
    let item: OnboardingItem
    weak var delegate: OnboardingItemDelegate?
        
    init(delegate: OnboardingItemDelegate, index: Int, item: OnboardingItem) {
        self.delegate = delegate
        self.index = index
        self.item = item
        super.init(nibName: nil, bundle: nil)
        view.backgroundColor = ThemeProvider.shared.calendarViewBackgroungColor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var actionButton: UIButton = {
        let button = HighButton(type: .roundedRect)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(item.buttonType == .next ? "Next" : "Start", for: .normal)
        button.layer.cornerRadius = 8
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.layer.borderWidth = 1
        button.clipsToBounds = true
        button.backgroundColor = .blue
        button.setTitleColor(.white, for: .normal)
        button.setTitleColor(.white, for: .highlighted)
        button.addTarget(self, action: #selector(actionButtonWasPressed(_:)), for: .touchUpInside)
        return button
    }()
    
    lazy var skipButton: UIButton = {
        let button = UIButton(type: .roundedRect)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = .preferredFont(forTextStyle: .caption1)
        button.setTitleColor(.darkGray, for: .normal)
        button.setTitle("Skip", for: .normal)
        return button
    }()
    
    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 8
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .gray
        imageView.image = item.image
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(forTextStyle: .headline)
        label.text = item.title
        label.numberOfLines = 3
        label.textAlignment = .center
        return label
    }()
    
    lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = item.subtitle
        label.numberOfLines = 3
        label.textAlignment = .center
        label.font = .preferredFont(forTextStyle: .footnote)
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(actionButton)
        let margins = view.layoutMarginsGuide
        
        NSLayoutConstraint.activate([
            actionButton.centerXAnchor.constraint(equalTo: margins.centerXAnchor),
            margins.bottomAnchor.constraint(equalTo: actionButton.bottomAnchor, constant: 16),
            actionButton.widthAnchor.constraint(equalTo: margins.widthAnchor, multiplier: 0.5),
            actionButton.heightAnchor.constraint(equalTo: margins.heightAnchor, multiplier: 0.05)
        ])
        
        view.addSubview(skipButton)
        NSLayoutConstraint.activate([
            skipButton.topAnchor.constraint(equalTo: margins.topAnchor, constant: 16),
            margins.trailingAnchor.constraint(equalTo: skipButton.trailingAnchor),
        ])
        
        view.addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: skipButton.bottomAnchor, constant: 16),
            imageView.leadingAnchor.constraint(equalTo: margins.leadingAnchor, constant: 0),
            imageView.trailingAnchor.constraint(equalTo: margins.trailingAnchor, constant: 0),
        ])
        
        //init subtitle
        view.addSubview(subtitleLabel)
        NSLayoutConstraint.activate([
            actionButton.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 8),
            subtitleLabel.centerXAnchor.constraint(equalTo: margins.centerXAnchor, constant: 0),
            subtitleLabel.leadingAnchor.constraint(equalTo: margins.leadingAnchor),
            subtitleLabel.trailingAnchor.constraint(equalTo: margins.trailingAnchor),
        ])
        
        //init title
        view.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8),
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            titleLabel.leadingAnchor.constraint(equalTo: margins.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: margins.trailingAnchor),
        ])
    }
    
    @objc func actionButtonWasPressed(_ sender: UIButton) {
        delegate?.buttomWasTapped(type: item.buttonType)
    }

}
