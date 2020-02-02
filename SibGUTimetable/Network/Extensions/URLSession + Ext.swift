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
import CoreData

extension URLSession {
    
    func doRequest<T : Decodable>(_ request: URLRequest) -> Single<T> {
        return Single<T>.create { (single) -> Disposable in
            let task = self.dataTask(with: request, completionHandler: { (data, response, error) in
                if error != nil {
                    single(.error(ServerError.connectionError))
                } else if let response = response as? HTTPURLResponse, let data = data {
                    switch response.statusCode {
                    case 200:
//                        if T.self == NSManagedObject.self {
//                            AppDelegate.backgroundContext.perform {
//                                do {
//                                    let decoder = JSONDecoder()
//    //                                print("LOGDATA", String(data: data, encoding: .utf8))
//                                    let decodeData = try decoder.decode(T.self, from: data)
//                                    single(.success(decodeData))
//                                } catch {
//                                    single(.error(ServerError.invalidJsonData))
//                                }
//                            }
//                        } else {
//                        AppDelegate.backgroundContext.perform {
//
//                        }
                        DispatchQueue.main.async {
                            do {
                                let decoder = JSONDecoder()
//                                print("LOGDATA", String(data: data, encoding: .utf8))
                                let decodeData = try decoder.decode(T.self, from: data)
                                single(.success(decodeData))
                            } catch {
                                single(.error(ServerError.invalidJsonData))
                            }
                        }
                        
                    case 400:
                        single(.error(ServerError.invalidRequest))
                    case 401:
                        single(.error(ServerError.notAuthorized))
                    case 404:
                        single(.error(ServerError.notFound))
                    case 500...526:
                        single(.error(ServerError.serverError))
                    default:
                        single(.error(ServerError.unknownError))
                    }
                } else {
                    single(.error(ServerError.unknownError))
                }
            })
            task.resume()
            
            return Disposables.create {
                task.cancel()
            }
        }.subscribeOn(ConcurrentDispatchQueueScheduler.init(qos: .userInitiated))
    }
    
}
