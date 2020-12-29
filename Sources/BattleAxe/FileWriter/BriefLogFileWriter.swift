//
//  BriefLogFileWriter.swift
//  
//
//  Created by Francesco Bianco on 15/12/2020.
//

import Foundation

/// FileWriter that stores logs in a more compact format:
/// `message [number of times]\n`
public final class BriefLogFileWriter: FileWriter {
    
    public var rotationConfiguration: RotatorConfiguration
    
    private var filePath: String
    private var fileSeeker: BAFileSeeker
    private var queue: DispatchQueue
    private static let queueName: String = "SmallLogFileWriter"
    private var filename: String
    private let manager: BAFileManager
    
    // Specific for this type of FileWriter:
    // It keeps a reference of the last message that has been sent.
    // If the last message is the same as the actual one, it increases the count.
    private var lastMessage: String?
    private var counter: Int = 1
    
    public init(filename: String,
                appGroup: String? = nil,
                rotationConfiguration: RotatorConfiguration = .standard,
                fileManager: BAFileManager = .default,
                fileSeeker: BAFileSeeker = BAFileAppender(fileSystemController: FileManager.default)) {
        
        guard let url = fileManager.baseURLFor(appGroup: appGroup) else {
            fatalError("Unable to get logs url.")
        }
        manager = fileManager
        self.rotationConfiguration = rotationConfiguration
        self.filename = filename
        self.queue = DispatchQueue(label: Self.queueName, qos: .utility)
        self.fileSeeker = fileSeeker
        do {
            guard let path = try manager.createLogsFolderIfNeeded(url.path) else {
                fatalError("Unable to create a subdirectory.")
            }
            let completePath = path + "/" + filename + BAFileManager.fileExtension
            self.filePath = completePath
            self.fileSeeker.open(at: completePath)
        } catch let error {
            fatalError(error.localizedDescription)
        }
    }
    
    public func fileData() -> String {
        guard let data = FileManager.default.contents(atPath: self.filePath),
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
            
            guard let unMessage = lastMessage else {
                let check = rotationConfiguration.check(filePath,
                                                        filename,
                                                        pendingData: message.data(using: .utf8) ?? Data())
                
                guard check else {
                    _ = manager.rotateLogsFile(filePath,
                                                filename: filename,
                                                rotationConfiguration: rotationConfiguration)
                    // We close and make the file handle reference nil, so the getFileHandle() mehod returns a
                    // brand new file.
                    fileSeeker.close()
                    
                    message.appendTo(file: fileSeeker)
                    strongSelf.lastMessage = message
                    strongSelf.counter = 1
                    return
                }
                message.appendTo(file: fileSeeker)
                strongSelf.lastMessage = message
                strongSelf.counter = 1
                return
            }
            
            if message == unMessage {
                strongSelf.counter += 1
            } else {
                " [\(strongSelf.counter) times]\n".appendTo(file: fileSeeker)
                strongSelf.counter = 1
                strongSelf.lastMessage = message
                message.appendTo(file: fileSeeker)
            }
        })
    }
    
    public func deleteLogs() {
        _ = manager.deleteAllLogs(filePath: self.filePath, filename: filename)
    }
}
