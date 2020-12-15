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
    init(maxSize: Int = 0,
         maxAge: TimeInterval = 0) {
        self.maxSize = maxSize
        self.maxAge = maxAge
    }
    
    /// Checks if the file on the specified path satisfies the maxAge, maxSize requirements.
    /// - Parameters:
    ///   - filePath: The path where the file is located.
    ///   - pendingData: The data that the FileWriter is going to write.
    /// - Returns: **True** if the conditions are satisfied, so the file could be updated.
    ///  **False** if one or both the conditions are not satisfied. In this case a new file is required.
    func check(_ filePath: String,
               pendingData: Data) -> Bool {
        
        guard let information = try? FileManager.default.attributesOfItem(atPath: filePath) else {
            return true
        }
        
        guard let fileSize = information[.size] as? UInt64 else {
            return true
        }
        
        guard let age = information[.creationDate] as? Date else {
            return true
        }
        
        let fits = doesItFit(fileSize, pendingData.count)
        let older = isOlder(age)
        
        return fits && !older
    }
    
    func doesItFit(_ fileSize: UInt64,
                   _ pendingDataSize: Int) -> Bool {
        
        guard maxSize != 0 else {
            return true
        }
        
        if Int(fileSize) + pendingDataSize >= maxSize {
            return false
        } else {
            return true
        }
    }
    
    func isOlder(_ date: Date) -> Bool {
        
        guard maxAge != 0 else {
            return false
        }
        
        let timeIntervalFromCreationSinceNow = Date().timeIntervalSince(date)
        if timeIntervalFromCreationSinceNow >= maxAge {
            return true
        } else {
            return false
        }
    }
    
}
