import Foundation

public struct ConsoleLogProvider: LogProvider {
    
    public var logIdentifier: String
    
    private var dateFormatter: DateFormatter
    public var channels: Set<String> = .init([LogService.defaultChannel])
    
    public init(dateFormatter: DateFormatter,
                identifier: String = "ConsoleLog Provider") {
        self.dateFormatter = dateFormatter
        self.logIdentifier = identifier
    }
    
    public func log(_ message: LogMessage) {
        
        guard !channels.isEmpty else {
            self.printLog(message)
            return
        }
        
        if channels.contains(message.channel) {
            self.printLog(message)
        }
    }
    
    private func printLog(_ message: LogMessage) {
        switch LogService.shared.configuration {
        case .standard:
            print("{\(message.channel)}[\(message.severity.prettyDescription) \(dateFormatter.getCurrentDateAsString())] \(message.callingFilePath):\(message.callingStackFrame):\(message.callingFileLine) \(message.payload)")
        case .minimal:
            print("{\(message.channel)}[\(message.severity.prettyDescription) \(dateFormatter.getCurrentDateAsString())] \(message.callingStackFrame) \(message.payload)")
        default:
            print("{\(message.channel)}[\(message.severity.prettyDescription) \(dateFormatter.getCurrentDateAsString())] \(message.payload)")
        }
    }
}
