import Foundation

public final class FileLogProvider: LogProvider {
    
    public var logIdentifier: String
    public var channels: Set<String> = .init([LogService.defaultChannel])
    
    private var dateFormatter: DateFormatter
    private var fileWriter: FileWriter
    private var configuration: LoggerConfiguration
    private var ingredients: [LoggerConfiguration.LogIngredient]
    
    public init(dateFormatter: DateFormatter,
                fileWriter: FileWriter,
                identifier: String = "Default FileLogProvider",
                configuration: LoggerConfiguration = LogService.shared.configuration) {
        self.dateFormatter = dateFormatter
        self.fileWriter = fileWriter
        self.logIdentifier = identifier
        self.configuration = configuration
        self.ingredients = configuration.ingredients.sorted()
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
    
    public func addChannel(_ channel: String) {
        channels.insert(channel)
    }
    
    public func removeChannel(_ channel: String) {
        channels.remove(channel)
    }
    
}

private extension FileLogProvider {
    
    func evaluate(_ message: LogMessage) {
        guard !channels.isEmpty else {
            writeLog(message: message)
            return
        }
        
        if channels.contains(message.channel) {
            writeLog(message: message)
        }
    }
    
    func writeLog(message: LogMessage) {
        if let _ = fileWriter as? BriefLogFileWriter {
            fileWriter.write("[\(message.severity.prettyDescription) \(message.callingFilePath):\(message.callingStackFrame):\(message.callingFileLine)] \(message.payload)")
        } else {
            let finalMessage = LogMessageFormatter.compose(message, using: ingredients, dateFormatter: dateFormatter)
            fileWriter.write(finalMessage)
        }
    }
}
