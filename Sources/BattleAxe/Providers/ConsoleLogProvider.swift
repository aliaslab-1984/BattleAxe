import Foundation

public struct ConsoleLogProvider: LogProvider {
    
    private var dateFormatter: DateFormatter
    
    public init(dateFormatter: DateFormatter) {
        self.dateFormatter = dateFormatter
    }
    
    public func log(_ severity: LogSeverity, message: String, file: String, function: String, line: Int) {
        switch LogService.shared.configuration {
        case .standard:
            print("[\(severity.prettyDescription) \(dateFormatter.getCurrentDateAsString())] \(file):\(function):\(line) \(message)")
        case .minimal:
            print("[\(severity.prettyDescription) \(dateFormatter.getCurrentDateAsString())] \(function) \(message)")
        default:
            print("[\(severity.prettyDescription) \(dateFormatter.getCurrentDateAsString())] \(message)")
        }
    }
}
