//
//  NetworkResult.swift
//  SibGUTimetable
//
//  Created by Alexandr on 20.10.2019.
//  Copyright © 2019 Alexandr. All rights reserved.
//

import Foundation

enum NetworkResult<T> {
    case success(T)
    case error(Error)
}
