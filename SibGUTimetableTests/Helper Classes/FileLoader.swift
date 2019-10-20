//
//  FileLoader.swift
//  SibGUTimetableTests
//
//  Created by Alexandr on 20.10.2019.
//  Copyright © 2019 Alexandr. All rights reserved.
//

import Foundation

@testable import SibGUTimetable

class FileLoader {
    
    static let shared = FileLoader()

    private init() { }
    
    func getPath(ofFile fileName: String) -> String {
        let bundle = Bundle(for: type(of: self))
        let bundlePath = bundle.bundlePath
        let filePath = bundlePath + "/" + fileName
        return filePath
    }
    
    func getLocalSchedule() -> Schedule {
        let jsonFilePath = getPath(ofFile: "schedule.json")
        let scheduleJson = try! String(contentsOfFile: jsonFilePath)
        
        let decoder = JSONDecoder()
        let schedule = try! decoder.decode(Schedule.self, from: scheduleJson.data(using: .utf8)!)
        return schedule
    }
    
}
