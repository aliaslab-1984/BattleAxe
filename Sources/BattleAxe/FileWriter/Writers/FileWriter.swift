import Foundation

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
        return FileWriterConfiguration(filename: name, appGroup: appGroup, queueName: queueName, rotationConfiguration: .standard, fileManager: .default, fileSeeker: BAFileController(fileSystemController: FileManager.default))
    }
    
    public init(filename: String,
                appGroup: String?,
                queueName: String,
                rotationConfiguration: RotatorConfiguration,
                fileManager: BAFileManager,
                fileSeeker: BAFileSeeker) {
        self.filename = filename
        self.appGroup = appGroup
        self.queueName = queueName
        self.rotationConfiguration = rotationConfiguration
        self.fileManager = fileManager
        self.fileSeeker = fileSeeker
    }
    
}

public protocol FileWriter {
    
    var rotationConfiguration: RotatorConfiguration { get }
    func write(_ message: String)
    func deleteLogs()
    
    init(_ configuration: FileWriterConfiguration)
}
