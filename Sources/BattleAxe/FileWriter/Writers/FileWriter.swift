import Foundation

/// A file writer is an object that is capable of writing a specific message into
/// a file. It is also able to rotate the log files using a specified rotation policy.
public protocol FileWriter {
    
    /// how the rotation of log files should be handled.
    var rotationConfiguration: RotatorConfiguration { get }
    
    /// This method handles the writing of the logs into a file.
    /// - Parameter message: What is going to be written on the file.
    func write(_ message: String)
    
    /// Deletes all the log files that have been written.
    func deleteLogs()
    
    init(_ configuration: FileWriterConfiguration)
}
