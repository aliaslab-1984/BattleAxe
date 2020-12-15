//
//  SmallLogFileWriter.swift
//  
//
//  Created by Francesco Bianco on 15/12/2020.
//

import Foundation

public final class SmallLogFileWriter: FileWriter {
    
    private var filePath: String
    private var fileHandle: FileHandle?
    private var queue: DispatchQueue
    private static let queueName: String = "SmallLogFileWriter"
    private var filename: String?
    
    private var lastMessage: String?
    private var counter: Int = 1
    
    public init(filename: String,
                appGroup: String? = nil) {
        let fileManager = FileManager.default
        
        let url: URL
        if let group = appGroup {
            guard let customURL = fileManager.containerURL(forSecurityApplicationGroupIdentifier: group) else {
                fatalError("Impossible to retreive appgroup url.")
            }
            url = customURL
        } else {
            guard let customURL = try? fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) else {
                fatalError("Impossible to retreive default logs URL.")
            }
            url = customURL
        }
        
        self.filename = filename
        self.queue = DispatchQueue(label: Self.queueName, qos: .utility)
        do {
            guard let path = try BattleAxeFileManager.createLogsFolderIfNeeded(url.path) else {
                fatalError("Unable to create a subdirectory.")
            }
            self.filePath = path + "/" + filename + ".logs"
        } catch let error {
            fatalError(error.localizedDescription)
        }
    }
    
    public init(filePath: String) {
        self.filePath = filePath
        self.queue = DispatchQueue(label: Self.queueName, qos: .utility)
    }
    
    public func fileData() -> String {
        guard let data = FileManager.default.contents(atPath: self.filePath),
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
            defer {
                fileHandle?.closeFile()
            }
            
            guard let strongSelf = self,
                  let file = strongSelf.getFileHandle() else {
                return
            }
            
            guard let unMessage = lastMessage else {
                if let data = message.data(using: String.Encoding.utf8) {
                    file.seekToEndOfFile()
                    file.write(data)
                }
                strongSelf.lastMessage = message
                strongSelf.counter = 1
                return
            }
            
            if message == unMessage {
                strongSelf.counter += 1
            } else {
                if let data = " [\(strongSelf.counter) times]\n".data(using: String.Encoding.utf8) {
                    file.seekToEndOfFile()
                    file.write(data)
                }
                strongSelf.counter = 1
                strongSelf.lastMessage = message
            }
        })
    }
    
    // The file will have the following format: `message [number of times]\n`
    
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
