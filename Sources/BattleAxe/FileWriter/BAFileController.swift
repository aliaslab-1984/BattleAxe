//
//  File.swift
//  
//
//  Created by Francesco Bianco on 30/12/2020.
//

import Foundation

// - MARK: BAFileController
public final class BAFileController: BAFileSeeker {
    
    private var fileHandle: FileHandle?
    private var path: String?
    private var fileSystem: FileSystemController
    
    public init(fileSystemController: FileSystemController) {
        self.fileSystem = fileSystemController
    }
    
    public func open(at path: String) {
        self.path = path
        restoreFileIfNeeded()
    }
    
    public func write(_ data: Data) {
        restoreFileIfNeeded()
        seekToEnd()
        
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
    
    public func readAll() -> Data? {
        restoreFileIfNeeded()
        
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
    
    public func close() {
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

}

private extension BAFileController {
    
    func restoreFileIfNeeded() {
        guard let unwrappedPath = path else {
            return
        }
        if !fileSystem.fileExists(atPath: unwrappedPath, isDirectory: nil) {
            fileSystem.createFile(atPath: unwrappedPath, contents: nil, attributes: nil)
        }

        fileHandle = FileHandle(forWritingAtPath: unwrappedPath)
    }
    
    func seekToEnd() {
        restoreFileIfNeeded()
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
    
}
