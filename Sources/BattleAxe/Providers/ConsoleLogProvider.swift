import Foundation

public struct ConsoleLogProvider: LogProvider {
    
    public var logIdentifier: String
    
    private var dateFormatter: DateFormatter
    
    public init(dateFormatter: DateFormatter,
                identifier: String = "ConsoleLog Provider") {
        self.dateFormatter = dateFormatter
        self.logIdentifier = identifier
    }
    
    public func log(_ message: LogMessage) {
        switch LogService.shared.configuration {
        case .standard:
            print("[\(message.severity.prettyDescription) \(dateFormatter.getCurrentDateAsString())] \(message.callingFilePath):\(message.callingStackFrame):\(message.callingFileLine) \(message.payload)")
        case .minimal:
            print("[\(message.severity.prettyDescription) \(dateFormatter.getCurrentDateAsString())] \(message.callingStackFrame) \(message.payload)")
        default:
            print("[\(message.severity.prettyDescription) \(dateFormatter.getCurrentDateAsString())] \(message.payload)")
        }
    }
}
