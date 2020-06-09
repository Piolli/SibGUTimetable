//
//  PageViewController.swift
//  SibGUTimetable
//
//  Created by Александр Камышев on 30.01.2020.
//  Copyright © 2020 Alexandr. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxRelay

//Uses in delegate
enum CustomizablePageViewMoveDirection: Int {
    case forward = 1
    case backward = -1
}

//T - field that iterable (index)
//C - content view controller class
class CustomizablePageViewController<T: Comparable, C: UIViewController> : UIPageViewController, UIPageViewControllerDelegate {
    
    lazy var pageDidMoveDirection: PublishRelay<CustomizablePageViewMoveDirection> = .init()
    lazy var tableViewOffsetDidChange: PublishRelay<CGPoint> = .init()
    
    var customizableDataSource: CustomizablePageViewDataSource<T, C>? {
        didSet {
            let vc = self.customizableDataSource!.select(iterableValue: self.customizableDataSource!.iterableValue)
            attachPublishRelay(with: vc)
            setViewControllers([vc], direction: .forward, animated: false, completion: nil)
        }
    }
    
    override var dataSource: UIPageViewControllerDataSource? {
        didSet {
            if let ds = self.dataSource as? CustomizablePageViewDataSource<T, C> {
                customizableDataSource = ds
            } else {
                fatalError("dataSource type doesn't comform to CustomizablePageViewDataSource<T, C>")
            }
        }
    }
    
    override init(transitionStyle style: UIPageViewController.TransitionStyle, navigationOrientation: UIPageViewController.NavigationOrientation, options: [UIPageViewController.OptionsKey : Any]? = nil) {
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        commonSetup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func commonSetup() {
        delegate = self
        dump(gestureRecognizers)
    }
    
    func select(iterableValue: T) {
        if customizableDataSource?.iterableValue == iterableValue {
            logger.debug("User selected the same page")
            return
        }
        
        if let newSelectedViewController = self.customizableDataSource?.select(iterableValue: iterableValue) {
            setViewControllers([newSelectedViewController], direction: .forward, animated: true, completion: nil)
        }
    }
    
    func attachPublishRelay(with viewController: UIViewController) {
        (viewController as? TimetableLessonListController)?.contentOffsetDidChange = { [weak self] point in
            self?.tableViewOffsetDidChange.accept(point)
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        guard let customizableDataSource = customizableDataSource else {
            //TODO logger
            fatalError("CustomizablePageViewController: Attach data source!")
        }
        
        if completed {
            if let selectedPageContentView = pageViewController.viewControllers?.first as? C {
                let selectedIterableValue = customizableDataSource.extractIterableValueFromController( selectedPageContentView)
                
                attachPublishRelay(with: selectedPageContentView)
                
                if selectedIterableValue > customizableDataSource.iterableValue {
                    pageDidMoveDirection.accept(.forward)
                } else if selectedIterableValue < customizableDataSource.iterableValue {
                    pageDidMoveDirection.accept(.backward)
                }
                customizableDataSource.iterableValue = selectedIterableValue
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
}
