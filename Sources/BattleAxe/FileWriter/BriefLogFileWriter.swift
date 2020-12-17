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
    private var fileHandle: FileHandle?
    private var queue: DispatchQueue
    private static let queueName: String = "SmallLogFileWriter"
    private var filename: String?
    
    private var lastMessage: String?
    private var counter: Int = 1
    
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
        fileHandle?.closeFile()
    }
    
    public func write(_ message: String) {
        queue.sync(execute: { [weak self] in
            guard let strongSelf = self,
                  let file = strongSelf.getFileHandle() else {
                return
            }
            
            guard let unMessage = lastMessage else {
                message.appendTo(file: file)
                strongSelf.lastMessage = message
                strongSelf.counter = 1
                return
            }
            
            if message == unMessage {
                strongSelf.counter += 1
            } else {
                " [\(strongSelf.counter) times]\n".appendTo(file: file)
                strongSelf.counter = 1
                strongSelf.lastMessage = message
                message.appendTo(file: file)
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
