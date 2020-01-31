//
//  MockNetworkSession.swift
//  SibGUTimetableTests
//
//  Created by Alexandr on 20.10.2019.
//  Copyright © 2019 Alexandr. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import XCTest

@testable import SibGUTimetable

//class MockNetworkSession<T> : NetworkSession where T : Decodable {
//    var data: T?
//    var error: Error?
//    
//    func loadData<T>(url: String) -> Observable<T> where T : Decodable {
//        return Observable.create { [data, error] (observer) -> Disposable in
//            if let url = URL(string: url) {
//                if error != nil {
//                    observer.onError(error!)
//                }
//                if data != nil {
//                    observer.onNext(data! as! T)
//                } else {
//                    observer.onError(NSError(domain: "MockNetworkSession", code: 100, userInfo: ["desc": "data is nil"]))
//                }
//            } else {
//                observer.onError(NSError(domain: "MockNetworkSession", code: 100, userInfo: ["desc": "url is invalid"]))
//            }
//
//            return Disposables.create()
//        }
//    }
//}
