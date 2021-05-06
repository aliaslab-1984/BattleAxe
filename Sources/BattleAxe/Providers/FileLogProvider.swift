import Foundation

public struct FileLogProvider: LogProvider {
    
    public var logIdentifier: String
    
    private var dateFormatter: DateFormatter
    private var fileWriter: FileWriter
    
    public init(dateFormatter: DateFormatter,
                fileWriter: FileWriter,
                identifier: String = "Default FileLogProvider") {
        self.dateFormatter = dateFormatter
        self.fileWriter = fileWriter
        self.logIdentifier = identifier
    }
    
    public func log(_ severity: LogSeverity, message: String, file: String, function: String, line: Int) {
        if let _ = fileWriter as? BriefLogFileWriter {
            fileWriter.write("[\(severity.prettyDescription) \(file):\(function):\(line)] \(message)")
        } else {
            fileWriter.write("[\(severity.prettyDescription) \(dateFormatter.getCurrentDateAsString()) \(file):\(function):\(line)] \(message)")
        }
    }
    
    public func log(_ message: LogMessage) {
        if let _ = fileWriter as? BriefLogFileWriter {
            fileWriter.write("[\(message.severity.prettyDescription) \(message.callingFilePath):\(message.callingStackFrame):\(message.callingFileLine)] \(message.payload)")
        } else {
            fileWriter.write("[\(message.severity.prettyDescription) \(dateFormatter.getCurrentDateAsString()) \(message.callingFilePath):\(message.callingStackFrame):\(message.callingFileLine)] \(message.payload)")
        }
    }
}
