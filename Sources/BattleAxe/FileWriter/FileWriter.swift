import Foundation

public protocol FileWriter {
    
    var rotationConfiguration: RotatorConfiguration { get }
    func write(_ message: String)
    func deleteLogs()
    
    init(filename: String,
         appGroup: String?,
         rotationConfiguration: RotatorConfiguration,
         fileManager: BAFileManager,
         fileSeeker: BAFileSeeker)
}
