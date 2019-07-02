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
    var pageContentDelegate: CalendarPageViewContentChanged? {
        didSet {
            pageContentDelegate?.pageViewContentCollectionHeightChanged(collectionViewHeight: (produceViewController(at: 0)!).collectionView?.contentSize.height ?? 0)
        }
    }
    
    // MARK: Variables
    
    private var index = 0
    
    
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
        
        setViewControllers([produceViewController(at: 0)!], direction: .forward, animated: true, completion: nil)
        
        
    }
    
    // MARK: Required methods
    
    func produceViewController(at index: Int) -> CalendarPageContentViewController? {
        if index < 0 || index >= countOfPages() {
            return nil
        }
        
        let pageContent = CalendarPageContentViewController()
        pageContent.viewModel = viewModel.calendarPageViewModelFor(index: index)
        pageContent.index = index
        
        return pageContent
    }
    
    func countOfPages() -> Int {
        return viewModel.countOfMonths()
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
        if completed {
            if let selectedPageContentView = pageViewController.viewControllers?.first as? CalendarPageContentViewController {
                
                selectedPageContentView.collectionView.layoutIfNeeded()
                let contentHeight = selectedPageContentView.collectionView?.contentSize.height ?? 0
                pageContentDelegate?.pageViewContentCollectionHeightChanged(collectionViewHeight: contentHeight + CalendarPageContentViewController.Constansts.headerViewHeight)
            }
        }
        
    }
    
    
}
