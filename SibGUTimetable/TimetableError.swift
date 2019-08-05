//
//  TimetableError.swift
//  SibGUTimetable
//
//  Created by Alexandr on 27/07/2019.
//  Copyright © 2019 Alexandr. All rights reserved.
//

import Foundation

enum TimetableError: Error, LocalizedError {
    case readFromLocalDataStoreError, anotherError
    
    var errorDescription: String? {
        switch self {
        case .readFromLocalDataStoreError:
            return "Error while reading from local data store"
        case .anotherError:
            return "Another error"
        default:
            return "No Description"
        }
    }
}
