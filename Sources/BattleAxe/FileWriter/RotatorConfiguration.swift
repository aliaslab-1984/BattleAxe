//
//  RotatatingLogHandler.swift
//  
//
//  Created by Francesco Bianco on 15/12/2020.
//

import Foundation

public final class RotatorConfiguration {
    
    enum RotationConfigurationError: Error {
        case invalidParameter
    }
    
    /// The maximum file size, in bytes.
    let maxSize: Int
    
    /// The maximum age for the file, in seconds.
    let maxAge: TimeInterval
    
    /// The maximum number of log files (excluding the current one).
    /// The max number that could be set is 9 for now.
    let maxFiles: Int
    
    /// A pre-build configuration with no limitations on size, age or number of files.
    public static let none = RotatorConfiguration(0, 0, 0)
    /// The default configuration: the max size is set to 1 MegaByte and the max number of files is 2. The max age is not set.
    public static let standard = RotatorConfiguration(1.megaBytes, 0, 2)
    
    /// The **maxSize** should be in bytes, for example: if you want to have a max size of 10 megabytes, use the `Int` extension:
    /// `RotatingLohHandler(maxSize: 10.megaBytes)`.
    /// The same applies to the **maxAge** parameter. Use the `Double` (`TimeInterval`) extension
    /// to make it easier to read:
    /// `RotatingLohHandler(maxAge: 10.0.daysToSeconds)`
    /// - Parameters:
    ///   - maxSize: The max size for the file. In Bytes. Default is 0.
    ///   - maxAge: The max age for the file. In Seconds. Default is 0.
    public convenience init(maxSize: Int,
                            maxAge: TimeInterval,
                            maxFiles: Int) throws {
        guard 0...9 ~= maxFiles else {
            throw RotationConfigurationError.invalidParameter
        }
        self.init(maxSize, maxAge, maxFiles)
    }
    
    private init(_ maxSize: Int,
                 _ maxAge: TimeInterval,
                 _ maxFiles: Int) {
        self.maxSize = maxSize
        self.maxAge = maxAge
        self.maxFiles = maxFiles
    }
    
    /// Checks if the file on the specified path satisfies the maxAge, maxSize requirements.
    /// - Parameters:
    ///   - pendingData: The data that the FileWriter is going to write.
    ///   - directoryPath: The path where the current logs file is located.
    ///   - fileName: The filename of the current logs file.
    /// - Returns: **True** if the conditions are satisfied, so the file could be updated.
    ///  **False** if one or both the conditions are not satisfied. In this case a new file is required.
    func check(_ filePath: String,
               _ fileName: String,
               pendingData: Data,
               using controller: FileSystemController = FileManager.default) -> Bool {
        
        // If the configuration is set to `.none`, we don't need to read any file,
        // the check result should always be true. (faster.)
        guard maxAge != 0 || maxSize != 0 || maxFiles != 0 else {
            return true
        }
        
        guard !filePath.isEmpty else {
            return false
        }
        
        guard let information = try? controller.attributesOfItem(atPath: filePath) else {
            return false
        }
        
        guard let fileSize = information[.size] as? UInt64 else {
            return false
        }
        
        guard let age = information[.creationDate] as? Date else {
            return false
        }
        
        let directoryPath = filePath.replacingOccurrences(of: "/" + fileName + BAFileManager.fileExtension, with: "")
        
        guard let items = try? controller.contentsOfDirectory(atPath: directoryPath) else {
            return true
        }
        
        let fits = doesItFits(fileSize, pendingData.count)
        let below = belowMaxAge(age)
        let excedes = belowMaxNumberOfFiles(items.count - 1)
        
        return fits && below && excedes
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
    func belowMaxAge(_ date: Date) -> Bool {
        
        guard maxAge > 0 else {
            return true
        }
        
        let timeIntervalFromCreationSinceNow = Date().timeIntervalSince(date)
        if timeIntervalFromCreationSinceNow >= maxAge {
            return false
        } else {
            return true
        }
    }
    
    /// Simple method that determines if the current number of files is below the maxFiles threshold.
    /// - Parameter numberOfFiles: The current number of files in the Logs folder.
    /// - Returns: **True** if the number id below the max threshold, **false** if it excedes the threshold.
    func belowMaxNumberOfFiles(_ numberOfFiles: Int) -> Bool {
        guard maxFiles != 0 else {
            return false
        }
        
        return numberOfFiles < maxFiles
    }
    
}
