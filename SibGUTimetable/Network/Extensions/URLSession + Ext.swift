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
    
    fileprivate func decodeJSON<T : Decodable>(decoder: JSONDecoder, data: Data) -> SingleEvent<T> {
        do {
            let decodeData = try decoder.decode(T.self, from: data)
            return .success(decodeData)
        } catch {
            return .error(ServerError.invalidJsonData)
        }
    }
    
    func doRequest<T : Decodable>(_ request: URLRequest, jsonDecoder: JSONDecoder = JSONDecoder()) -> Single<T> {
        return Single<T>.create { [weak self] (single) -> Disposable in
            guard let self = self else {
                single(.error(ServerError.invalidRequest))
                return Disposables.create()
            }
            
            let task = self.dataTask(with: request, completionHandler: { (data, response, error) in
                if error != nil {
                    single(.error(ServerError.connectionError))
                } else if let response = response as? HTTPURLResponse, let data = data {
                    switch response.statusCode {
                    case 200...299:
                        //Check out context for NSManagedObject parsing
                        if let context = jsonDecoder.userInfo[CodingUserInfoKey.context!] as? NSManagedObjectContext {
                            context.perform {
                                single(self.decodeJSON(decoder: jsonDecoder, data: data))
                            }
                        } else {
                            single(self.decodeJSON(decoder: jsonDecoder, data: data))
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
