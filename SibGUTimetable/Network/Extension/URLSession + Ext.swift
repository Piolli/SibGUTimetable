//
//  URLSession + Ext.swift
//  SibGUTimetable
//
//  Created by Alexandr on 20.10.2019.
//  Copyright © 2019 Alexandr. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

extension URLSession : NetworkSession {
    
    func loadData<T>(url: String) -> Observable<T> where T : Decodable {
        guard let url = URL(string: url) else {
            Logger.logMessageInfo(message: "loadData URL is nil")
            return Observable.error(
                NSError(domain: "NativeNetworkManager", code: 101, userInfo: ["desc": "invalid url string"])
            )
        }
        
        return Observable<T>.create({ (observer) -> Disposable in
            let task = URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
                if let error = error {
                    observer.onError(error)
                }
                
                DispatchQueue.main.async {
                    do {
                        let decoder = JSONDecoder()
                        let decodeData = try decoder.decode(T.self, from: data ?? Data())
                        observer.onNext(decodeData)
                    } catch {
                        observer.onError(error)
                    }
                    observer.onCompleted()
                }
            })
            task.resume()
            
            return Disposables.create {
                task.cancel()
            }
        })
    }
    
}
