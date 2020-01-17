//
//  ServerAPI.swift
//  SibGUTimetable
//
//  Created by Александр Камышев on 11.01.2020.
//  Copyright © 2020 Alexandr. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa


struct PairIDName : Decodable {
    let id: Int
    let name: String
}
    

protocol APIServer {
    
    func findGroup(queryGroupName: String) -> Single<[PairIDName]>
    
    func fetchTimetable(groupId: Int, groupName: String) -> Single<Timetable>
    
}

enum ServerError : Error {
    case connectionError
    case serverError
    case notFound
    case invalidResponse
    case invalidJsonData
    case invalidRequest
    case unknownError
    case notAuthorized
}

public class NativeAPIServer : APIServer {
    
    public lazy var sharedInstance = NativeAPIServer()
    
    public init() { }
    
    func findGroup(queryGroupName: String) -> Single<[PairIDName]> {
        if let url = makeGETWithParams(path: "http://127.0.0.1:5000/group", params: ["query": queryGroupName]) {
            let req = URLRequest(url: url)
            return URLSession.shared.doRequest(req)
        }
        return Single.error(ServerError.invalidRequest)
    }
    
    func makeGETWithParams(path: String, params: [String: String]) -> URL? {
        var urlComponents = URLComponents(string: path)
        urlComponents?.queryItems = params.map { URLQueryItem(name: $0, value: $1) }
        return urlComponents?.url
    }

    func fetchTimetable(groupId: Int, groupName: String) -> Single<Timetable> {
        fatalError()
    }
    
}
