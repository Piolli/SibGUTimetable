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
class CustomizablePageViewController<T, C: UIViewController> : UIPageViewController {
    
//    var ds: CustomizablePageViewDataSource<T, C>
    var pageDidMoveDirection: PublishRelay<CustomizablePageViewMoveDirection>!
    var customizableDataSource: CustomizablePageViewDataSource<T, C>? {
        didSet {
            let vc = self.customizableDataSource!.select(iterableValue: self.customizableDataSource!.iterableValue)
            setViewControllers([vc], direction: .forward, animated: true, completion: nil)
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
    
    func commonSetup() {
        pageDidMoveDirection = .init()
    }
    
    override init(transitionStyle style: UIPageViewController.TransitionStyle, navigationOrientation: UIPageViewController.NavigationOrientation, options: [UIPageViewController.OptionsKey : Any]? = nil) {
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: options)
        commonSetup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonSetup()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
}

extension CustomizablePageViewController {
    
    
    
}
