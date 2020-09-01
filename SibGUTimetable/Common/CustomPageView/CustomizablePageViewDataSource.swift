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
    
    typealias ControllerBuilder = (T) -> C?
    typealias ModifyIterableValue = (T) -> T
    typealias Extractor = (C) -> T
    
    public let error: PublishRelay<PageViewError> = .init()
    
    var iterableValue: T
    let contentBuilderFunction: ControllerBuilder
    let nextIterableValueFunction: ModifyIterableValue
    let previousIterableValueFunction: ModifyIterableValue
    let extractIterableValueFromControllerFunction: Extractor
    
    var nextIterableValue: T {
        return nextIterableValueFunction(iterableValue)
    }
    
    var previousIterableValue: T {
        return previousIterableValueFunction(iterableValue)
    }
    
    //TODO: make descriptions for each parameter
    init(startIterableValue: T, contentBuilder: @escaping ControllerBuilder, nextIterableValue: @escaping ModifyIterableValue, previousIterableValue: @escaping ModifyIterableValue, extractIterableValueFromController: @escaping Extractor) {
        self.contentBuilderFunction = contentBuilder
        self.nextIterableValueFunction = nextIterableValue
        self.previousIterableValueFunction = previousIterableValue
        self.iterableValue = startIterableValue
        self.extractIterableValueFromControllerFunction = extractIterableValueFromController
    }
    
    func select(iterableValue: T) -> UIViewController? {
        guard let viewController = contentBuilderFunction(iterableValue) else {
            logger.error("contentBuilder returns nil, iterableValue: \(iterableValue)")
            return nil
        }
        let value = extractIterableValueFromControllerFunction(viewController)
        self.iterableValue = value
        return viewController
    }
    
    func move(isForward: Bool, viewController: UIViewController) -> UIViewController? {
        guard let viewController = viewController as? C else {
            logger.error("viewController isn't C type")
            error.accept(.viewControllerIsNil)
            return nil
        }
        let iterableValue = extractIterableValueFromControllerFunction(viewController)
        let previousValue = isForward ? nextIterableValueFunction(iterableValue) : previousIterableValueFunction(iterableValue)
        return contentBuilderFunction(previousValue)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        move(isForward: false, viewController: viewController)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        move(isForward: true, viewController: viewController)
    }

    
}
