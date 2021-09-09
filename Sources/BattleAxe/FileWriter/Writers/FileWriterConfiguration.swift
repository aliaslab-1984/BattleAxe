//
//  FileWriterConfiguration.swift
//  
//
//  Created by Francesco Bianco on 09/09/21.
//

import Foundation

/// This data structure contains all the information that is required to write
/// to a file.
/// This is supposed to only be a descriptor and not an active actor during the writing.
/// See `FileWriter` protocol to see it's usage.
public struct FileWriterConfiguration {
    
    public var filename: String
    public var appGroup: String?
    public var queueName: String
    public var rotationConfiguration: RotatorConfiguration
    public var fileManager: BAFileManager
    public var fileSeeker: BAFileSeeker
    
    public static func defaultConfig(name: String,
                                     queueName: String,
                                     appGroup: String? = nil) -> FileWriterConfiguration {
        
        return FileWriterConfiguration(filename: name,
                                       appGroup: appGroup,
                                       queueName: queueName,
                                       rotationConfiguration: .standard,
                                       fileManager: .standard,
                                       fileSeeker: BAFileController(fileSystemController: FileManager.default))
    }
    
    public init(filename: String,
                appGroup: String?,
                queueName: String,
                rotationConfiguration: RotatorConfiguration,
                fileManager: BAFileManager,
                fileSeeker: BAFileSeeker) {
        self.filename = filename
        self.appGroup = appGroup
        self.queueName = queueName
        self.rotationConfiguration = rotationConfiguration
        self.fileManager = fileManager
        self.fileSeeker = fileSeeker
    }
    
}
