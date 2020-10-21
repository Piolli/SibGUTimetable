//
//  ObservableType+Ext.swift
//  SibGUTimetable
//
//  Created by Александр Камышев on 29.01.2020.
//  Copyright © 2020 Alexandr. All rights reserved.
//

import Foundation
import RxSwift
import RxRelay
import RxCocoa

public extension ObservableType {
    /**
     Converts an Observable into another Observable that emits the whole sequence as a single array sorted using the provided closure and then terminates.
     - parameter by: A comparator closure to sort emitted elements.
     - returns: An observable sequence containing all the sorted emitted elements as an array.
    */
    func toSortedArray(by: @escaping (Element, Element) -> Bool) -> Single<[Element]> {
        return toArray().map { $0.sorted(by: by) }
    }
}

public extension ObservableType where Element: Comparable {
    /**
     Converts an Observable into another Observable that emits the whole sequence as a single sorted array and then terminates.
     - parameter ascending: Should the emitted items be ascending or descending.
     - returns: An observable sequence containing all the sorted emitted elements as an array.
    */
    func toSortedArray(ascending: Bool = true) -> Single<[Element]> {
        return toSortedArray(by: { ascending ? $0 < $1 : $0 > $1 })
    }
}

public extension ObservableType {
    func trackErrors(_ observer: PublishRelay<Error>) -> Observable<Self.Element> {
        return self.do( onError: { (error) in
            observer.accept(error)
        })
    }
    
    func asDriverOnErrorJustReturnEmpty(_ isLogging: Bool = true) -> Driver<Self.Element> {
        return self.asDriver { (error) -> Driver<Self.Element> in
            if isLogging {
                logger.error("Cast Observable to Driver: \(error.localizedDescription). Return .empty()")
            }
            return .empty()
        }
    }
}
