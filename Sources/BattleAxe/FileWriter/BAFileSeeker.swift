//
//  File.swift
//  
//
//  Created by Francesco Bianco on 29/12/2020.
//

import Foundation

public protocol BAFileSeeker {
    
    func write(_ data: Data)
    func close()
    func readAll() -> Data?
}

final class BAFileAppender: BAFileSeeker {
    
    private var fileHandle: FileHandle?
    private var path: String
    private var fileSystem: FileSystemController
    
    init(path: String,
         fileSystemController: FileSystemController) {
        self.path = path
        self.fileSystem = fileSystemController
        if !fileSystemController.fileExists(atPath: path, isDirectory: nil) {
            fileSystemController.createFile(atPath: path, contents: nil, attributes: nil)
        }

        fileHandle = FileHandle(forWritingAtPath: path)
    }
    
    private func seekToEnd() {
        restoreFileifNeeded()
        if #available(iOS 13.4, macOS 10.15.4, *) {
            do {
            try fileHandle?.seekToEnd()
            } catch _ {
                // handle error..
            }
        } else {
            fileHandle?.seekToEndOfFile()
        }
    }
    
    func write(_ data: Data) {
        restoreFileifNeeded()
        self.seekToEnd()
        
        if #available(iOS 13.4, macOS 10.15.4, *) {
            do {
                try fileHandle?.write(contentsOf: data)
            } catch _ {
                // handle error
            }
        } else {
            fileHandle?.write(data)
        }
    }
    
    func readAll() -> Data? {
        restoreFileifNeeded()
        
        if #available(iOS 13.4, macOS 10.15.4, *) {
            do {
                let data = try fileHandle?.readToEnd()
                return data
            } catch _ {
                // handle error
                return nil
            }
        } else {
            return fileHandle?.readDataToEndOfFile()
        }
        
    }
    
    func close() {
        if #available(iOS 13.4, macOS 10.15.4, *) {
            do {
                try fileHandle?.close()
            } catch _ {
                // handle error
            }
        } else {
            fileHandle?.closeFile()
        }
        
        fileHandle = nil
    }
    
    private func restoreFileifNeeded() {
        if !fileSystem.fileExists(atPath: path, isDirectory: nil) {
            fileSystem.createFile(atPath: path, contents: nil, attributes: nil)
        }

        fileHandle = FileHandle(forWritingAtPath: path)
    }

}
