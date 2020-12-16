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
    
    /// The **maxSize** should be in bytes, for example: if you want to have a max size of 10 megabytes, use the `Int` extension:
    /// `RotatingLohHandler(maxSize: 10.megaBytes)`.
    /// The same applies to the **maxAge** parameter. Use the `Double` (`TimeInterval`) extension
    /// to make it easier to read:
    /// `RotatingLohHandler(maxAge: 10.0.daysToSeconds)`
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
    ///   - filePath: The path where the current logs file is located.
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
        
        let fits = doesItFits(fileSize, pendingData.count)
        let smaller = isSmaller(than: age)
        
        return fits && smaller
    }
    
    /// Determines if the pending data fits the **maxSize** requirements.
    /// - Parameters:
    ///   - fileSize: The current log filesize (in bytes).
    ///   - pendingDataSize: The pending data size (in bytes).
    /// - Returns: **True** if the requirements are fulfilled, otherwise **false**.
    func doesItFits(_ fileSize: UInt64,
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
    
    /// Determines if the logs file creation date fulfills the **maxAge** requirements.
    /// - Parameter date: The file's creation date.
    /// - Returns: **True** if the requirements are fulfilled, otherwise **false**.
    func isSmaller(than date: Date) -> Bool {
        
        guard maxAge != 0 else {
            return false
        }
        
        let timeIntervalFromCreationSinceNow = Date().timeIntervalSince(date)
        if timeIntervalFromCreationSinceNow >= maxAge {
            return false
        } else {
            return true
        }
    }
    
}
