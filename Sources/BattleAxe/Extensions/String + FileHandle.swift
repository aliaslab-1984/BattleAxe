//
//  File.swift
//  
//
//  Created by Francesco Bianco on 15/12/2020.
//

import Foundation


internal extension String {

    /// Appends the string to an existing file handle.
    /// - Parameter fileHandle: The FileHandle instance that will be used to write the String.
    func appendTo(file fileHandle: BAFileSeeker) {
        if let data = self.data(using: String.Encoding.utf8) {
            data.appendToFile(using: fileHandle)
        }
    }
    
    /// Extracts the filename from the filepath.
    var fileName: String {
        let components = self.components(separatedBy: "/")
        return components.isEmpty ? self : components.last!
    }
}

internal extension Data {

    /// Appends the current data to an existing file handle.
    /// - Parameter fileHandle: The FileHandle instance that will be used to write the String.
    func appendToFile(using fileHandle: BAFileSeeker) {
        fileHandle.write(self)
    }
}
