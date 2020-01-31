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
    
    private let host = "http://192.168.1.46:5001/"
    
    public static let sharedInstance = NativeAPIServer()
    
    func findGroup(queryGroupName: String) -> Single<[PairIDName]> {
        if let url = makeGETWithParams(path: "\(host)group", params: ["query": queryGroupName]) {
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
        let params: [String : String] = [
            "group_name": groupName,
            "id": String(groupId)
        ]
        
        if let url = makeGETWithParams(path: "\(host)timetable", params: params) {
            let request = URLRequest(url: url)
            return URLSession.shared.doRequest(request)
        }
        return Single.error(ServerError.invalidRequest)
    }
    
}
