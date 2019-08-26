//
//  CalendarPageViewController.swift
//  SibGUTimetable
//
//  Created by Alexandr on 25/06/2019.
//  Copyright © 2019 Alexandr. All rights reserved.
//

import UIKit


class CalendarPageViewController: UIPageViewController {

    let viewModel = CalendarViewModel()
    
    // MARK: delegates
    
    //TD: WEAK?
    weak var pageContentDelegate: CalendarPageViewContentChanged? {
        didSet {
//            pageContentDelegate?.pageViewContentCollectionHeightChanged(collectionViewHeight: (produceViewController(at: 0)!).collectionView?.contentSize.height ?? 0)
        }
    }
    
    // MARK: Variables
    
    private var currentIndex = 0
    
    private var currentDay = 0
    
    
    override init(transitionStyle style: UIPageViewController.TransitionStyle, navigationOrientation: UIPageViewController.NavigationOrientation, options: [UIPageViewController.OptionsKey : Any]? = nil) {
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: options)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        dataSource = self
        delegate = self
        
        let currentMonthPosition = viewModel.monthIndexOfCurrentDate()
        
        setViewControllers([produceViewController(at: currentMonthPosition)!], direction: .forward, animated: true, completion: nil)
        
        
    }
    
    // MARK: Required methods
    
    func produceViewController(at index: Int) -> CalendarPageContentViewController? {
        if index < 0 || index >= countOfPages() {
            return nil
        }
        
        let pageContent = CalendarPageContentViewController()
        pageContent.viewModel = viewModel.calendarPageViewModelFor(index: index)
        pageContent.index = index
        pageContent.delegate = self
//        pageContentDelegate?.pageViewContentChangedTo(newMonth: pageContent.viewModel.month)
        
        return pageContent
    }
    
    func countOfPages() -> Int {
        return viewModel.countOfMonths()
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

// MARK: PageView Data Source
extension CalendarPageViewController : UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        var index = (viewController as! CalendarPageContentViewController).index
        index -= 1
        
        return produceViewController(at: index)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        var index = (viewController as! CalendarPageContentViewController).index
        index += 1
        
        return produceViewController(at: index)
    }
}

extension CalendarPageViewController : UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
//        dump(previousViewControllers)
        if completed {
            if let selectedPageContentView = pageViewController.viewControllers?.first as? CalendarPageContentViewController {
                
//                selectedPageContentView.collectionView.layoutIfNeeded()
                var contentHeight = selectedPageContentView.collectionView?.contentSize.height ?? 0
                contentHeight += CalendarPageContentViewController.Constansts.headerViewHeight
                contentHeight -= CalendarPageContentViewController.Constansts.minimumLineSpacing
                
                pageContentDelegate?.pageViewContentCollectionHeightChanged(collectionViewHeight: contentHeight + CalendarPageContentViewController.Constansts.headerViewHeight)
                
                pageContentDelegate?.pageViewContentChangedTo(newMonth: selectedPageContentView.viewModel.month)
                
                currentIndex = selectedPageContentView.index
            }
        }
    }

}


//MARK: - CalendarContentViewDelegate
extension CalendarPageViewController : CalendarContentViewDelegate {
    
    func cellWasSelectedWith(month: CalendarParser.CalendarMonth, day: Int) {
        pageContentDelegate?.pageViewContentCellDidSelected(month: month, day: day)
        currentDay = day
    }
    
}
