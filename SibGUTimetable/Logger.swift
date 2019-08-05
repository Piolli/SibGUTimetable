//
//  Logger.swift
//  SibGUTimetable
//
//  Created by Alexandr on 27/07/2019.
//  Copyright © 2019 Alexandr. All rights reserved.
//

import Foundation
import os

class Logger {
    
    enum LogType: String {
        case
        info = "INFO",
        error = "ERROR",
        debug = "DEBUG"
    }
    
    static func logMessage(message: String? = nil, error: Error? = nil, file: String = #file, type: LogType = .info, line: Int = #line, function: String = #function) {
        
        let splitPath = file.split(separator: "/").last!
        
        let formatMacrosInfo = "\(splitPath):\(line) in \(function)"
        
        if var message = message {
            printMessage(message, logType: type, macrosInfo: formatMacrosInfo)
        } else if let error = error {
            printMessage(error.localizedDescription, logType: .error, macrosInfo: formatMacrosInfo)
        }
        
    }
    
    private static func printMessage(_ message: String, logType: LogType, macrosInfo: String) {
        let time = Date().timeIntervalSince1970
        
        var resultMessage = "|\(logType.rawValue)| \(String(time)), \(message) <\(macrosInfo)>"
    
        
        print(resultMessage)
    }

    

    
}
