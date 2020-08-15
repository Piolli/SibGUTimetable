//
//  FeedbackViewController.swift
//  SibGUTimetable
//
//  Created by Александр Камышев on 15.08.2020.
//  Copyright © 2020 Alexandr. All rights reserved.
//

import UIKit

class FeedbackViewController: UIViewController {
    
    lazy var coreIssueInputView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        let inputLabel = UILabel()
        inputLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(inputLabel)
        inputLabel.text = "Core issue"
        
        let inputTextField = UITextField()
        inputTextField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(inputTextField)
        inputTextField.borderStyle = .roundedRect
        inputTextField.text = ""
        
        self.contraint(label: inputLabel, withInput: inputTextField, to: view)
        
        return view
    }()
    
    lazy var additionalCommentsInputView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        let inputLabel = UILabel()
        inputLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(inputLabel)
        inputLabel.text = "Additional comments"
        
        let inputTextField = UITextView()
        inputTextField.layer.borderColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0).cgColor
        inputTextField.layer.borderWidth = 1.0
        inputTextField.layer.cornerRadius = 5
        
        inputTextField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(inputTextField)
        inputTextField.heightAnchor.constraint(equalToConstant: 150).isActive = true
        inputTextField.text = ""
        
        self.contraint(label: inputLabel, withInput: inputTextField, to: view)
        
        return view
    }()
    
    private func contraint(label: UIView, withInput input: UIView, to view: UIView) {
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            label.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            label.topAnchor.constraint(equalTo: view.topAnchor),
            
            input.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 8),
            input.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            input.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            input.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
    lazy var contentView: UIView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(coreIssueInputView)
        stackView.addArrangedSubview(additionalCommentsInputView)
        return stackView
    }()
    
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentView)
        return scrollView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupScrollView()
    }
    
    private func setupScrollView() {
        
        view.addSubview(scrollView)
        
        let frameGuide = scrollView.frameLayoutGuide
        let contentGuide = scrollView.contentLayoutGuide
        
        let superViewGuide = view.layoutMarginsGuide
        NSLayoutConstraint.activate([
            frameGuide.leadingAnchor.constraint(equalTo: superViewGuide.leadingAnchor),
            frameGuide.trailingAnchor.constraint(equalTo: superViewGuide.trailingAnchor),
            frameGuide.topAnchor.constraint(equalTo: superViewGuide.topAnchor),
            frameGuide.bottomAnchor.constraint(equalTo: superViewGuide.bottomAnchor),
            frameGuide.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            
            contentGuide.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            contentGuide.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            contentGuide.topAnchor.constraint(equalTo: contentView.topAnchor),
            contentGuide.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        
    }
    
    private func setupCreateBarButton() {
        
    }
    
    private func setupCancelBarButton() {
        
    }

}
