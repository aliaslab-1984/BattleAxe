import Foundation

public struct FileWriterConfiguration {
    
    public var filename: String
    public var appGroup: String?
    public var queueName: String
    public var rotationConfiguration: RotatorConfiguration
    public var fileManager: BAFileManager
    public var fileSeeker: BAFileSeeker
    
    public static func defaultConfig(name: String, queueName: String) -> FileWriterConfiguration {
        return FileWriterConfiguration(filename: name, appGroup: nil, queueName: queueName, rotationConfiguration: .standard, fileManager: .default, fileSeeker: BAFileController(fileSystemController: FileManager.default))
    }
    
}

public protocol FileWriter {
    
    var rotationConfiguration: RotatorConfiguration { get }
    func write(_ message: String)
    func deleteLogs()
    
    init(_ configuration: FileWriterConfiguration)
}
