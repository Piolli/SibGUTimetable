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
    
    lazy var skipButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        //todo: translate
        button.titleLabel?.text = "Skip"
        button.isHidden = true
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupOnboardingPageView()
        view.bringSubviewToFront(skipButton)
    }
    
    lazy var onboardingItems: [OnboardingItemViewController.OnboardingItem] = {
        return [
            .init(title: "Title post post post post post post post post post post post post post post post post post post post post post post post post post post post", subtitle: "Subtitle ", image: UIImage(), buttonType: .next),
            .init(title: "Title", subtitle: "Subtitle post post post post post post post post post post post post post post post post post post post post post post post post post post post post post post post post post post post post post post", image: UIImage(), buttonType: .next),
            .init(title: "Third slide slide slide slide slide slide slide slide slide slide slide slide slide slide slide slide slide slide slide slide slide slide slide slide slide slide slide slide", subtitle: "Subtitle post post post post post post post post post post post post post post post post post post post post post post post post post post post post post post post post post post post post post post post post", image: UIImage(), buttonType: .start),
        ]
    }()
    
    lazy var onboardingItemViewControllers: [OnboardingItemViewController] = {
        return onboardingItems.map { (item) -> OnboardingItemViewController in
            return OnboardingItemViewController(delegate: self, index: onboardingItems.firstIndex(where: { $0 == item })!, item: item)
        }
    }()
    
    private func setupOnboardingPageView() {
        addPageView()
        disableHorizontalBounce()
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
    
    private func disableHorizontalBounce() {
        for view in onboardingPageView.view.subviews {
           if let scrollView = view as? UIScrollView {
              scrollView.delegate = self
           }
        }
    }

}

//MARK: - OnboardingItemDelegate
//Get events from embedded ViewControllers into UIPageViewController
extension OnboardingViewController: OnboardingItemDelegate {
    
    func buttomWasTapped(type: OnboardingItemViewController.ActionButtonType) {
        logger.debug("type: \(type)")
        switch type {
        case .next:
            onboardingPageView.movePage(.forward)
        case .start:
            //TODO: create coordinator for router interactions
//        self.coordinator.openMainScreen()
            break
        }
        
    }
    
    func skipButtomWasTapped() {
        //TODO: create coordinator for router interactions
//        self.coordinator.openMainScreen()
    }
    
}

//MARK: - UIScrollViewDelegate
//Uses for disabling horizontal bounce
extension OnboardingViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let selectedPageIndex = self.pageViewDataSource.iterableValue
        if (selectedPageIndex == 0 && scrollView.contentOffset.x < scrollView.bounds.size.width) {
            scrollView.contentOffset = CGPoint(x: scrollView.bounds.size.width, y: 0);
        } else if (selectedPageIndex == onboardingItems.count - 1 && scrollView.contentOffset.x > scrollView.bounds.size.width) {
            scrollView.contentOffset = CGPoint(x: scrollView.bounds.size.width, y: 0);
        }
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let selectedPageIndex = self.pageViewDataSource.iterableValue
        if (selectedPageIndex == 0 && scrollView.contentOffset.x <= scrollView.bounds.size.width) {
            targetContentOffset.pointee = CGPoint(x: scrollView.bounds.size.width, y: 0);
        } else if (selectedPageIndex == onboardingItems.count - 1 && scrollView.contentOffset.x >= scrollView.bounds.size.width) {
            targetContentOffset.pointee = CGPoint(x: scrollView.bounds.size.width, y: 0);
        }
    }
}
