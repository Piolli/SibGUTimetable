//
//  OnboardingViewController.swift
//  SibGUTimetable
//
//  Created by Александр Камышев on 26.08.2020.
//  Copyright © 2020 Alexandr. All rights reserved.
//

import UIKit


class OnboardingViewController: UIViewController {
    
    lazy var onboardingPageView = CustomizablePageViewController<Int, OnboardingItemViewController>()
    var pageViewDataSource: CustomizablePageViewDataSource<Int, OnboardingItemViewController>!
    unowned var coordinator: OnboardingCoordinator!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupOnboardingPageView()
        view.backgroundColor = ThemeProvider.shared.calendarViewBackgroungColor
    }
    
    lazy var onboardingItems: [OnboardingItemViewController.OnboardingItem] = {
        return [
            .init(title: LocalizedStrings.Offline_timetable, subtitle: LocalizedStrings.Offline_timetable_description, image: UIImage(), buttonType: .next),
            .init(title: LocalizedStrings.Dark_Mode, subtitle: LocalizedStrings.Dark_Mode_description, image: UIImage(), buttonType: .next),
            .init(title: LocalizedStrings.Calendar, subtitle: LocalizedStrings.Calendar_description, image: UIImage(), buttonType: .start),
        ]
    }()
    
    lazy var onboardingItemViewControllers: [OnboardingItemViewController] = {
        return onboardingItems.map { (item) -> OnboardingItemViewController in
            return OnboardingItemViewController(delegate: self, index: onboardingItems.firstIndex(where: { $0 == item })!, item: item)
        }
    }()
    
    private func setupOnboardingPageView() {
        addPageView()
        setupDataSource()
    }
    
    private func addPageView() {
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(containerView)
        
        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            containerView.topAnchor.constraint(equalTo: view.topAnchor),
            containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        add(viewController: onboardingPageView, to: containerView)
    }
    
    private func setupDataSource() {
        pageViewDataSource = .init(startIterableValue: 0, contentBuilder: { [weak self] (i) -> OnboardingItemViewController? in
            guard let self = self, i >= 0  && i < self.onboardingItems.count else {
                logger.error("self is nil or 'i' isn't in bounds")
                return nil
            }
            return self.onboardingItemViewControllers[i]
        }, nextIterableValue: { (i) -> Int in
            return i + 1
        }, previousIterableValue: { (i) -> Int in
            return i - 1
        }, extractIterableValueFromController: { (v) -> Int in
            return v.index
        })
        onboardingPageView.dataSource = pageViewDataSource
    }

}

//MARK: - OnboardingItemDelegate
//Get events from embedded ViewControllers into UIPageViewController
extension OnboardingViewController: OnboardingItemDelegate {
    
    func buttomWasTapped(type: OnboardingItemViewController.ActionButtonType) {
        logger.debug("type: \(type)")
        switch type {
        case .next:
            onboardingPageView.move(.forward)
        case .start:
            coordinator.close()
        }
    }
    
    func skipButtomWasTapped() {
        coordinator.close()
    }
    
}
