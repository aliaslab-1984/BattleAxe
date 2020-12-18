//
//  FullLogFileWriter.swift
//
//
//  Created by Francesco Bianco on 15/12/2020.
//

import Foundation

public final class StandardLogFileWriter: FileWriter {
    
    public var rotationConfiguration: RotatorConfiguration
    
    private var filePath: String
    private var filename: String
    private var fileHandle: FileHandle?
    private var queue: DispatchQueue
    private static let queueName: String = "FullLogFileWriter"
    
    public init(filename: String,
                appGroup: String? = nil,
                rotationConfiguration: RotatorConfiguration = .standard) {
        
        guard let url = BAFileManager.standard.baseURLFor(appGroup: appGroup) else {
            fatalError("Unable to get logs url.")
        }
        
        self.rotationConfiguration = rotationConfiguration
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
    
    /// Returns the URL where the log collection is stored.
    public func logsURL() -> URL? {
        return URL(string: filePath)
    }
    
    deinit {
        fileHandle?.closeFile()
    }
    
    public func write(_ message: String) {
        queue.sync(execute: { [weak self] in
            
            guard let strongSelf = self else {
                return
            }
            
            // We need to check if the rotator's check passes before writing.
            let check = rotationConfiguration.check(strongSelf.filePath,
                                                    strongSelf.filename,
                                                    pendingData: message.data(using: .utf8) ?? Data())
            guard check else {
                _ = BAFileManager
                            .standard
                            .rotateLogsFile(strongSelf.filePath,
                                            filename: strongSelf.filename,
                                            rotationConfiguration: rotationConfiguration)
                // We close and make the file handle reference nil, so the getFileHandle() mehod returns a
                // brand new file.
                fileHandle?.closeFile()
                fileHandle = nil
                
                self?.writeAndCR(message)
                return
            }
            
            self?.writeAndCR(message)
        })
    }
    
    private func writeAndCR(_ message: String) {
        if let file = self.getFileHandle() {
            let printed = message + "\n"
            printed.appendTo(file: file)
        }
    }
    
    public func deleteLogs() {
        _ = BAFileManager.standard.deleteAllLogs(filePath: self.filePath, filename: filename)
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
