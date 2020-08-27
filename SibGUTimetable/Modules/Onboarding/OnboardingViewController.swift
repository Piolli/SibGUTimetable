//
//  OnboardingViewController.swift
//  SibGUTimetable
//
//  Created by Александр Камышев on 26.08.2020.
//  Copyright © 2020 Alexandr. All rights reserved.
//

import UIKit

class OnboardingViewController: UIViewController {
    
    lazy var onboarding = CustomizablePageViewController<Int, OnboardingItemViewController>()
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
    
    lazy var onboardingItems: [OnboardingItemViewController] = {
        return (0...2).map { (i) -> OnboardingItemViewController in
            return OnboardingItemViewController(index: i, item: .init(title: "Title \(i)", subtitle: "Subtitle \(i)", image: UIImage(), buttonType: .next))
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
        
        add(viewController: onboarding, to: containerView)
    }
    
    private func setupDataSource() {
        pageViewDataSource = .init(startIterableValue: 0, contentBuilder: { [weak self] (i) -> OnboardingItemViewController? in
            guard let self = self, i >= 0  && i < self.onboardingItems.count else {
                logger.error("self is nil or 'i' isn't in bounds")
                return nil
            }
            return self.onboardingItems[i]
        }, nextIterableValue: { (i) -> Int in
            return i + 1
        }, previousIterableValue: { (i) -> Int in
            return i - 1
        }, extractIterableValueFromController: { (v) -> Int in
            return v.index
        })
        onboarding.dataSource = pageViewDataSource
    }
    
    private func disableHorizontalBounce() {
        for view in onboarding.view.subviews {
           if let scrollView = view as? UIScrollView {
              scrollView.delegate = self
           }
        }
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
