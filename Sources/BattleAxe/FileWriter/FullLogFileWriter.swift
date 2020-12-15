//
//  FullLogFileWriter.swift
//
//
//  Created by Francesco Bianco on 15/12/2020.
//

import Foundation

public final class StandardLogFileWriter: FileWriter {
    
    private var filePath: String
    private var filename: String
    private var fileHandle: FileHandle?
    private var queue: DispatchQueue
    private static let queueName: String = "FullLogFileWriter"
    
    public init(filename: String,
                appGroup: String? = nil) {
        
        guard let url = BAFileManager.standard.baseURLFor(appGroup: appGroup) else {
            fatalError("Unable to get logs url.")
        }
        
        self.filename = filename
        self.queue = DispatchQueue(label: Self.queueName, qos: .utility)
        do {
            guard let path = try BAFileManager.standard.createLogsFolderIfNeeded(url.path) else {
                fatalError("Unable to create a subdirectory.")
            }
            self.filePath = path + "/" + filename + BAFileManager.fileExtension
        } catch let error {
            fatalError(error.localizedDescription)
        }
    }
    
    /// Returns a string representation for the log collection.
    public func fileData() -> String {
        
        guard let data = getFileHandle()?.readDataToEndOfFile(),
              let stringRepresentation = String(data: data, encoding: .utf8) else {
            return ""
        }
        
        return stringRepresentation
    }
    
    deinit {
        fileHandle?.closeFile()
    }
    
    public func write(_ message: String) {
        queue.sync(execute: { [weak self] in
            
            let handler = RotatatingLogHandler()
            handler.check(self?.filePath ?? "")
            
            if let file = self?.getFileHandle() {
                let printed = message + "\n"
                printed.appendTo(file: file)
            }
        })
    }
    
    private func getFileHandle() -> FileHandle? {
        if fileHandle == nil {
            let fileManager = FileManager.default
            if !fileManager.fileExists(atPath: filePath) {
                fileManager.createFile(atPath: filePath, contents: nil, attributes: nil)
            }
            
            fileHandle = FileHandle(forWritingAtPath: filePath)
        }
        
        return fileHandle
    }
}
