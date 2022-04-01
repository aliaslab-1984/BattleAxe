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
            } catch let error {
                // handle error
                print("[🪓] Failed to update logs file: \(error.localizedDescription)")
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
            } catch let error {
                // handle error
                print("[🪓] Failed to read logs file: \(error.localizedDescription)")
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
            } catch let error {
                // handle error
                print("[🪓] Failed to close logs file: \(error.localizedDescription)")
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
            print("[🪓] Logs file path is null.")
            return
        }
        
        if !fileSystem.fileExists(atPath: unwrappedPath, isDirectory: nil) {
            fileSystem.createFile(atPath: unwrappedPath, contents: nil, attributes: nil)
        }
        
        if let handle = FileHandle(forUpdatingAtPath: unwrappedPath) {
            fileHandle = handle
        } else {
            print("[🪓] Unable to instantiate FileHandle")
        }
                  
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
