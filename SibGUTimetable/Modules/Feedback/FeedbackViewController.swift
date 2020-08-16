//
//  FeedbackViewController.swift
//  SibGUTimetable
//
//  Created by Александр Камышев on 15.08.2020.
//  Copyright © 2020 Alexandr. All rights reserved.
//

import UIKit

class FeedbackViewController: UIViewController {
    
    lazy var coreIssueTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.font = .preferredFont(forTextStyle: .callout)
        textField.leftView = .init(frame: .init(x: 0, y: 0, width: 4, height: 1))
        textField.leftViewMode = .always
        addBorderAndBackground(for: textField)
        return textField
    }()
    
    lazy var coreIssueInputView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        let inputLabel = UILabel()
        inputLabel.font = .preferredFont(forTextStyle: .subheadline)
        inputLabel.textColor = ThemeProvider.shared.secondaryLabelColor
        inputLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(inputLabel)
        inputLabel.text = "Core issue"
        
        view.addSubview(coreIssueTextField)
        coreIssueTextField.heightAnchor.constraint(equalToConstant: coreIssueTextField.font!.lineHeight + 16).isActive = true
        
        self.contraint(label: inputLabel, withInput: coreIssueTextField, to: view)
        
        return view
    }()
    
    lazy var additionalCommentsTextView: UITextView = {
        let inputTextField = UITextView()
        inputTextField.font = .preferredFont(forTextStyle: .callout)
        inputTextField.translatesAutoresizingMaskIntoConstraints = false
        addBorderAndBackground(for: inputTextField)
        return inputTextField
    }()
    
    lazy var additionalCommentsInputView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        let inputLabel = UILabel()
        inputLabel.textColor = ThemeProvider.shared.secondaryLabelColor
        inputLabel.font = .preferredFont(forTextStyle: .subheadline)
        inputLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(inputLabel)
        inputLabel.text = "Additional comments"
        
        view.addSubview(additionalCommentsTextView)
        additionalCommentsTextView.heightAnchor.constraint(equalToConstant: 150).isActive = true
        
        self.contraint(label: inputLabel, withInput: additionalCommentsTextView, to: view)
        
        return view
    }()
    
    private func addBorderAndBackground(for view: UIView) {
        view.layer.borderColor = ThemeProvider.shared.viewBorderColor.cgColor
        view.layer.borderWidth = 0.25
        view.layer.cornerRadius = 8
        view.backgroundColor = ThemeProvider.shared.tableViewBackgroundColor
    }
    
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
        stackView.spacing = 20
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(coreIssueInputView)
        stackView.addArrangedSubview(additionalCommentsInputView)
        return stackView
    }()
    
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.alwaysBounceVertical = true
        scrollView.contentInset = .init(top: 20, left: 0, bottom: 0, right: 0)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentView)
        return scrollView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = ThemeProvider.shared.calendarViewBackgroungColor
        setupScrollView()
        setupCreateBarButton()
        setupCancelBarButton()
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
        let createButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(createIssue))
        navigationItem.rightBarButtonItem = createButton
    }
    
    private func setupCancelBarButton() {
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelIssue))
        navigationItem.leftBarButtonItem = cancelButton
    }
    
    @objc private func createIssue() {
        guard let coreIssueText = coreIssueTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines),
              coreIssueText.count > 3 else {
            logger.error("Core Issue's text lenght <= 3")
            showMessage(text: "Core issue text is too short", title: "Error")
            return
        }
    }
    
    @objc private func cancelIssue() {
        
    }
    

}
