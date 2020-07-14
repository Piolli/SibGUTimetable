//
//  CustomLogHandler.swift
//  SibGUTimetable
//
//  Created by Александр Камышев on 08.06.2020.
//  Copyright © 2020 Alexandr. All rights reserved.
//

import Foundation
import Logging
import Darwin

struct CustomLogHandler : LogHandler {
    
    public let showMetadata: Bool
    
    init(showMetadata: Bool) {
        self.showMetadata = showMetadata
    }

    private let stream = StdioOutputStream.stdout

    func log(level: Logger.Level, message: Logger.Message, metadata: Logger.Metadata?, file: String, function: String, line: UInt) {
        var metadata = (showMetadata ? metadata : Logger.Metadata()) ?? Logger.Metadata()
        
        metadata["file"] = "\(file)"
        metadata["function (line)"] = "\(function) (\(String(line)))"
        
        let sortedMetadataArray = metadata.sorted(by: { $0.key < $1.key })
        let pretty = sortedMetadataArray
            .map { "\($0)=\($1)" }
            .joined(separator: "; ")
        
        stream.write("\(self.timestamp()) \(level): '\(message)' [\(pretty)]\n")
    }

    subscript(metadataKey metadataKey: String) -> Logger.Metadata.Value? {
        get {
            return self.metadata[metadataKey]
        }
        set(newValue) {
            self.metadata[metadataKey] = newValue
        }
    }

    private func prettify(_ metadata: Logger.Metadata) -> String? {
        return !metadata.isEmpty ? metadata.map { "\($0)=\($1)\n" }.joined(separator: " ") : nil
    }

    private var prettyMetadata: String?
    var metadata: Logger.Metadata = Logger.Metadata() {
        didSet {
            self.prettyMetadata = self.prettify(self.metadata)
        }
    }

    var logLevel: Logger.Level = .debug
    
    private func timestamp() -> String {
        var buffer = [Int8](repeating: 0, count: 255)
        var timestamp = time(nil)
        let localTime = localtime(&timestamp)
        strftime(&buffer, buffer.count, "%Y-%m-%dT%H:%M:%S%z", localTime)
        return buffer.withUnsafeBufferPointer {
            $0.withMemoryRebound(to: CChar.self) {
                String(cString: $0.baseAddress!)
            }
        }
    }

}

struct StdioOutputStream: TextOutputStream {
    internal let file: UnsafeMutablePointer<FILE>
    internal let flushMode: FlushMode

    internal func write(_ string: String) {
        string.withCString { ptr in
            flockfile(self.file)
            defer {
                funlockfile(self.file)
            }
            _ = fputs(ptr, self.file)
            if case .always = self.flushMode {
                self.flush()
            }
        }
    }

    /// Flush the underlying stream.
    /// This has no effect when using the `.always` flush mode, which is the default
    internal func flush() {
        _ = fflush(self.file)
    }

    internal static let stderr = StdioOutputStream(file: Darwin.stderr, flushMode: .always)
    internal static let stdout = StdioOutputStream(file: Darwin.stdout, flushMode: .always)

    /// Defines the flushing strategy for the underlying stream.
    internal enum FlushMode {
        case undefined
        case always
    }
}


