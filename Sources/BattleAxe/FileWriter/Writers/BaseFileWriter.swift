//
//  BaseFileWriter.swift
//  
//
//  Created by Francesco Bianco on 30/12/2020.
//

import Foundation

open class BaseFileWriter: FileWriter {
    
    public var rotationConfiguration: RotatorConfiguration
    
    public var filePath: String
    public var filename: String
    public var fileSeeker: BAFileSeeker
    public var queue: DispatchQueue
    public var queueName: String = ""
    public var manager: BAFileManager
    
    required public init(_ configuration: FileWriterConfiguration) {
        
        guard let url = configuration.fileManager.baseURLFor(appGroup: configuration.appGroup) else {
            fatalError("Unable to get logs url.")
        }
        
        self.manager = configuration.fileManager
        self.rotationConfiguration = configuration.rotationConfiguration
        self.filename = configuration.filename
        self.queue = DispatchQueue(label: configuration.queueName, qos: .utility)
        self.fileSeeker = configuration.fileSeeker
        do {
            guard let path = try configuration.fileManager.createLogsFolderIfNeeded(url.path) else {
                fatalError("Unable to create a subdirectory.")
            }
            let finalPath = path + "/" + filename + BAFileManager.fileExtension
            self.filePath = finalPath
            self.fileSeeker.open(at: finalPath)
        } catch let error {
            fatalError(error.localizedDescription)
        }
    }
    
    deinit {
        fileSeeker.close()
    }
    
    public func write(_ message: String) {
        // Does nothing
        fatalError("Subclasses need to implement the `write(_ message: String)` method.")
    }
    
    /// Returns the URL where the log collection is stored.
    @available(*, deprecated, message: "Use fileData() instead.")
    public func logsURL() -> URL? {
        return URL(string: filePath)
    }
    
    /// Returns a string representation for the log collection.
    public func fileData() -> String {
        
        guard let data = fileSeeker.readAll(),
              let stringRepresentation = String(data: data, encoding: .utf8) else {
            return ""
        }
        
        return stringRepresentation
    }
    
    public func deleteLogs() {
        _ = manager.deleteAllLogs(filePath: self.filePath, filename: filename)
    }

}
