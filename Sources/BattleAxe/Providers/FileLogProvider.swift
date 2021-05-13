import Foundation

public struct FileLogProvider: LogProvider {
    
    public var logIdentifier: String
    public var channels: Set<String> = .init([LogService.defaultChannel])
    
    private var dateFormatter: DateFormatter
    private var fileWriter: FileWriter
    
    public init(dateFormatter: DateFormatter,
                fileWriter: FileWriter,
                identifier: String = "Default FileLogProvider") {
        self.dateFormatter = dateFormatter
        self.fileWriter = fileWriter
        self.logIdentifier = identifier
    }
    
    public func log(_ severity: LogSeverity,
                    message: String,
                    file: String,
                    function: String,
                    line: Int,
                    channel: String?) {
        let message = LoggedMessage(payload: message, severity: severity, callingFilePath: file, callingFileLine: line, callingStackFrame: function, callingThreadID: UInt64(ProcessIdentification.current.processID), channel: channel ?? LogService.defaultChannel)
        evaluate(message)
    }
    
    public func log(_ message: LogMessage) {
        evaluate(message)
    }
    
    private func evaluate(_ message: LogMessage) {
        guard !channels.isEmpty else {
            writeLog(message: message)
            return
        }
        
        if channels.contains(message.channel) {
            writeLog(message: message)
        }
    }
    
    private func writeLog(message: LogMessage) {
        if let _ = fileWriter as? BriefLogFileWriter {
            fileWriter.write("[\(message.severity.prettyDescription) \(message.callingFilePath):\(message.callingStackFrame):\(message.callingFileLine)] \(message.payload)")
        } else {
            fileWriter.write("[\(message.severity.prettyDescription) \(dateFormatter.getCurrentDateAsString()) \(message.callingFilePath):\(message.callingStackFrame):\(message.callingFileLine)] \(message.payload)")
        }
    }
}
