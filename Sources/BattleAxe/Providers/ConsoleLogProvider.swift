import Foundation

public struct ConsoleLogProvider: LogProvider {
    
    private var dateFormatter: DateFormatter
    
    public init(dateFormatter: DateFormatter) {
        self.dateFormatter = dateFormatter
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
