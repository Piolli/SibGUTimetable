//
//  NetworkSession.swift
//  SibGUTimetable
//
//  Created by Alexandr on 20.10.2019.
//  Copyright © 2019 Alexandr. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol NetworkSession {
    
    func loadData<T : Decodable>(url: String) -> Observable<T>
    
}
