//
//  CustomizablePageViewDataSource.swift
//  SibGUTimetable
//
//  Created by Александр Камышев on 31.01.2020.
//  Copyright © 2020 Alexandr. All rights reserved.
//

import Foundation
import RxSwift
import RxRelay

//T - field that iterable (index)
//C - content view controller class
class CustomizablePageViewDataSource<T, C: UIViewController> : NSObject, UIPageViewControllerDataSource {
    
    enum PageViewError : Error {
        case viewControllerIsNil
    }
    
    typealias ControllerBuilder = (T) -> C
    typealias ModifyIterableValue = (T) -> T
    typealias Extractor = (C) -> T
    
    public let error: PublishRelay<PageViewError> = .init()
    
    var iterableValue: T
    let contentBuilder: ControllerBuilder
    let nextIterableValue: ModifyIterableValue
    let previousIterableValue: ModifyIterableValue
    let extractIterableValueFromController: Extractor
    
    init(startIterableValue: T, contentBuilder: @escaping ControllerBuilder, nextIterableValue: @escaping ModifyIterableValue, previousIterableValue: @escaping ModifyIterableValue, extractIterableValueFromController: @escaping Extractor) {
        self.contentBuilder = contentBuilder
        self.nextIterableValue = nextIterableValue
        self.previousIterableValue = previousIterableValue
        self.iterableValue = startIterableValue
        self.extractIterableValueFromController = extractIterableValueFromController
    }
    
    func select(iterableValue: T) -> UIViewController {
        let viewController = contentBuilder(iterableValue)
        let value = extractIterableValueFromController(viewController)
        self.iterableValue = value
        return viewController
    }
    
    func move(isForward: Bool, viewController: UIViewController) -> UIViewController? {
        guard let viewController = viewController as? C else {
            error.accept(.viewControllerIsNil)
            return nil
        }
        let iterableValue = extractIterableValueFromController(viewController)
        let previousValue = isForward ? nextIterableValue(iterableValue) : previousIterableValue(iterableValue)
        return contentBuilder(previousValue)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        move(isForward: false, viewController: viewController)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        move(isForward: true, viewController: viewController)
    }
    
}
