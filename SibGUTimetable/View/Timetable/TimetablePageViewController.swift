//
//  TimetablePageViewController.swift
//  SibGUTimetable
//
//  Created by Alexandr on 11/07/2019.
//  Copyright © 2019 Alexandr. All rights reserved.
//

import UIKit

class TimetablePageViewController: UIPageViewController {

    private var currentIndex = 0
    
    var viewModel: TimetableScheduleViewModel?
    
    override init(transitionStyle style: UIPageViewController.TransitionStyle, navigationOrientation: UIPageViewController.NavigationOrientation, options: [UIPageViewController.OptionsKey : Any]? = nil) {
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: options)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        dataSource = self
        delegate = self
        
        setViewControllers([produceViewController(at: 0)!], direction: .forward, animated: true, completion: nil)
    }
    
    func produceViewController(at index: Int) -> TimetableLessonPageContentViewController? {
        if index < 0 || index >= countOfPages() {
            return nil
        }
        
        let pageContent = TimetableLessonPageContentViewController()
        
        pageContent.viewModel = viewModel?.dayViewModel(at: index)
        pageContent.index = index

        
        return pageContent
    }
    
    func countOfPages() -> Int {
        return (viewModel?.countOfDays) ?? 0
    }
    
    // MARK: Attached to buttons - previous & next month in ScrollableCalendarView
    
    @objc func forwardPage() {
        currentIndex += 1
        if let nextVC = produceViewController(at: currentIndex) {
            setViewControllers([nextVC], direction: .forward, animated: true, completion: nil)
        } else {
            currentIndex -= 1
        }
    }
    
    @objc func backwardPage() {
        currentIndex -= 1
        if let nextVC = produceViewController(at: currentIndex) {
            setViewControllers([nextVC], direction: .reverse, animated: true, completion: nil)
        } else {
            currentIndex += 1
        }
    }


}

extension TimetablePageViewController : UIPageViewControllerDelegate {
    
}

extension TimetablePageViewController : UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        var index = (viewController as! TimetableLessonPageContentViewController).index
        index -= 1
        
        return produceViewController(at: index)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        var index = (viewController as! TimetableLessonPageContentViewController).index
        index += 1
        
        return produceViewController(at: index)
    }
    
    
}
