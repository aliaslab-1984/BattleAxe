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
        if !fileSystem.fileExists(atPath: path, isDirectory: nil) {
            fileSystem.createFile(atPath: path, contents: nil, attributes: nil)
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
    
    public func write(_ data: Data) {
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
    
    public func readAll() -> Data? {
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
    
    private func restoreFileifNeeded() {
        guard let unwrappedPath = path else {
            return
        }
        if !fileSystem.fileExists(atPath: unwrappedPath, isDirectory: nil) {
            fileSystem.createFile(atPath: unwrappedPath, contents: nil, attributes: nil)
        }

        fileHandle = FileHandle(forWritingAtPath: unwrappedPath)
    }

}
