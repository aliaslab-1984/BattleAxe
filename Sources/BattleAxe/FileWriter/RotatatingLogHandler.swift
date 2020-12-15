//
//  RotatatingLogHandler.swift
//  
//
//  Created by Francesco Bianco on 15/12/2020.
//

import Foundation

final class RotatatingLogHandler {
    
    /// The maximum file size, in bytes.
    let maxSize: Int
    
    /// The maximum age for the file, in seconds.
    let maxAge: TimeInterval
    
    /// The max size should be in bytes, for example: if you want to have a max size of 10 megabytes, use the Int extension:
    /// `RotatingLohHandler(maxSize: 10.megaBytes)`
    /// - Parameters:
    ///   - maxSize: The max size for the file. In Bytes. Default is 0.
    ///   - maxAge: The max age for the file. In Seconds. Default is 0.
    init(maxSize: Int = 10.kiloBytes,
         maxAge: TimeInterval = 0) {
        self.maxSize = maxSize
        self.maxAge = maxAge
    }
    
    func check(_ filePath: String) {
        
        guard let information = try? FileManager.default.attributesOfItem(atPath: filePath) else {
            return
        }
        
        guard let fileSize = information[.size] as? UInt64 else {
            return
        }
        
        if Int(fileSize) >= maxSize {
            print("Larger")
        } else {
            print("Smaller")
        }
    }
    
}
