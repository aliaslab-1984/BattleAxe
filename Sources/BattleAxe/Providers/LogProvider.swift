import Foundation

/// This protocol lets you create your custom log provider. Battle axe already has some providers, but if you need a specific bahavior just create an object that conforms to LogProvider, and add it to the LogService instance (using `register()`).
public protocol LogProvider {
    
    var logIdentifier: String { get set }
    
    /// Tells if a LogProvider should log only for a specific channel or not.
    /// If it's empty it means that it will log for every channel.
    var channels: Set<String> { get }
    
    /// This method gets called by the LogService every time the LogSerivce.shared.log() gets called. (If the logger is enabled and the minimum log level is lower than the logged severity)
    /// - Parameters:
    ///   - message: The message that's being logged.
    func log(_ message: LogMessage)
    
    func addChannel(_ channel: String)
    
    func removeChannel(_ channel: String)
}
