//
//  FileLoader.swift
//  SibGUTimetableTests
//
//  Created by Alexandr on 20.10.2019.
//  Copyright © 2019 Alexandr. All rights reserved.
//

import Foundation
import AcknowList

class FileLoader {
    
    static let shared = FileLoader()

    private init() { }
    
    func getPath(ofFile fileName: String) -> String {
        let bundle = Bundle(for: type(of: self))
        let bundlePath = bundle.bundlePath
        let filePath = bundlePath + "/" + fileName
        return filePath
    }
    
    func getAdditionalLicenses() -> [Acknow]? {
        let filePath = getPath(ofFile: "additional_licenses.json")
        do {
            if let data = try String(contentsOfFile: filePath).data(using: .utf8) {
                let decoder = JSONDecoder()
                return try decoder.decode([Acknow].self, from: data)
            } else {
                logger.error("file with path (\(filePath) doesn't exist")
            }
        } catch {
            logger.error("description: \(error.localizedDescription)")
        }
        return nil
        
    }
    
    func getLocalSchedule(decoder: JSONDecoder = JSONDecoder()) -> Timetable? {
        let jsonFilePath = getPath(ofFile: "schedule.json")
        if let scheduleJson = try? String(contentsOfFile: jsonFilePath) {
            let schedule = try! decoder.decode(Timetable.self, from: scheduleJson.data(using: .utf8)!)
            return schedule
        }
        return nil
    }
    
}
