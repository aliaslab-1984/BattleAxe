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
    private var fileSeeker: BAFileSeeker
    private var queue: DispatchQueue
    private static let queueName: String = "FullLogFileWriter"
    private let manager: BAFileManager
    
    public init(filename: String,
                appGroup: String? = nil,
                rotationConfiguration: RotatorConfiguration = .standard,
                fileManager: BAFileManager = .default) {
        
        guard let url = fileManager.baseURLFor(appGroup: appGroup) else {
            fatalError("Unable to get logs url.")
        }
        
        self.manager = fileManager
        self.rotationConfiguration = rotationConfiguration
        self.filename = filename
        self.queue = DispatchQueue(label: Self.queueName, qos: .utility)
        do {
            guard let path = try manager.createLogsFolderIfNeeded(url.path) else {
                fatalError("Unable to create a subdirectory.")
            }
            let finalPath = path + "/" + filename + BAFileManager.fileExtension
            self.filePath = finalPath
            self.fileSeeker = BAFileAppender(path: finalPath, fileSystemController: FileManager.default)
        } catch let error {
            fatalError(error.localizedDescription)
        }
    }
    
    /// Returns a string representation for the log collection.
    public func fileData() -> String {
        
        guard let data = fileSeeker.readAll(),
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
        fileSeeker.close()
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
                _ = manager.rotateLogsFile(strongSelf.filePath,
                                           filename: strongSelf.filename,
                                           rotationConfiguration: rotationConfiguration)
                // We close and make the file handle reference nil, so the getFileHandle() mehod returns a
                // brand new file.
                fileSeeker.close()
                
                self?.writeAndCR(message)
                return
            }
            
            self?.writeAndCR(message)
        })
    }
    
    private func writeAndCR(_ message: String) {
        let printed = message + "\n"
        printed.appendTo(file: fileSeeker)
    }
    
    public func deleteLogs() {
        _ = manager.deleteAllLogs(filePath: self.filePath, filename: filename)
    }
    
}
