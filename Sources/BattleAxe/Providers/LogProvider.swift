import Foundation

/// This protocol lets you create your custom log provider. Battle axe already has some providers, but if you need a specific bahavior just create an object that conforms to LogProvider, and add it to the LogService instance (using `register()`).
public protocol LogProvider {
    
    func log(_ message: LogMessage)
    
}
