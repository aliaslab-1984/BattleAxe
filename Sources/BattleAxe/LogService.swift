import Foundation

/// This is the main class, this will let you log from everywhere into your app/framework.
/// In order to log something just use the shared instance and choose a log level, the LogService will take care for propagating the log to your providers.
public final class LogService {
    
    /// The list of current providers. Managed internally by `LogService`
    private static var providers = [LogProvider]()
    
    /// The currently registered providers
    public static var currentProviders: [LogProvider] { return providers }
    
    /// Singleton instance.
    public static let shared = LogService()
    
    /// The minimum severity that will be displayed/saved. For reference see `LogSeverity` to
    /// see the rawValues.
    public var minimumSeverity: LogSeverity = .debug
    /// How the logs are displayed/saved. The `.standard` configuration gives you all the information such the date, the function name and the line number.
    public var configuration: LoggerConfiguration = .standard
    /// Whether the logging is enabled or not.
    public var enabled: Bool = true
    
    /// The default channel
    public static let defaultChannel: String = "BattleAxe 🪓"
    
    public typealias Dump = () -> Any
    
    // MARK: LogProvider lifecycle
    
    /// Adds a new LogProvider object to the list.
    public static func register(provider: LogProvider) {
        providers.append(provider)
    }
    
    /// Adds a new LogProvider object to the list.
    public static func unregister(provider: LogProvider) {
        guard let index = providers.firstIndex(where: { (item) -> Bool in
            item.logIdentifier == provider.logIdentifier &&
                item.channels == provider.channels
        }) else {
            return
        }
        
        providers.remove(at: index)
    }
    
    /// Removes all the registered providers.
    public static func empty() {
        self.providers = []
    }
    
    // MARK: Channel lifecycle
    
    /// Removes the passed channel to all the providers.
    /// - Parameter channel: the channel that is going to be removed.
    public static func silence(_ channel: String) {
        providers.forEach { provider in
            provider.removeChannel(channel)
        }
    }
    
    // MARK: Logging
    
    /// Adds the passed channel to all the providers.
    /// - Parameter channel: the channel that is going to be added. If a provider already uses the passed channel it won't duplicate.
    public static func add(_ channel: String) {
        providers.forEach { provider in
            provider.addChannel(channel)
        }
    }
    
    /// Convenience method.
    ///
    /// Same as `ifDebug(_ severity: LogSeverity, _ object: @autoclosure @escaping Dump, channel: String? = nil, filename: String = #file, funcName: String = #function, line:`, but with the fixed severity level of `.debugOnly`
    /// - Parameters:
    ///   - object: The message that should be displayed.
    ///   - filename: The filename
    ///   - funcName: The method name.
    ///   - line: The file's line.
    public func ifDebug(_ object: @autoclosure @escaping Dump,
                        channel: String? = nil,
                        filename: String = #file,
                        funcName: String = #function,
                        line: Int = #line) {
        ifDebug(.debugOnly, object, channel: channel, filename: filename, funcName: funcName, line: line)
    }
    
    /// Convenience method. Calls log only if the build configuration is set to DEBUG.
    /// It calls verbose(), debug() ... depending on the `LogSeverity` specified at the begining.
    /// - Parameters:
    ///   - severity: The log's severity.
    ///   - object: The message that should be displayed.
    ///   - filename: The filename
    ///   - funcName: The method name.
    ///   - line: The file's line.
    public func ifDebug(_ severity: LogSeverity,
                        _ object: @autoclosure @escaping Dump,
                        channel: String? = nil,
                        filename: String = #file,
                        funcName: String = #function,
                        line: Int = #line) {
        #if DEBUG
            log(severity, object, channel: channel, filename: filename, funcName: funcName, line: line)
        #else
            return
        #endif
    }
    
    /// Convenience method. It calls verbose(), debug() ... depending on the `LogSeverity` specified at the begining.
    /// - Parameters:
    ///   - severity: The log's severity.
    ///   - object: The message that should be displayed.
    ///   - filename: The filename
    ///   - funcName: The method name.
    ///   - line: The file's line.
    public func log(_ severity: LogSeverity,
                    _ object: @autoclosure @escaping Dump,
                    channel: String? = nil,
                    filename: String = #file,
                    funcName: String = #function,
                    line: Int = #line) {
        
        self.evaluate(severity: severity,
                      object,
                      channel: channel ?? Self.defaultChannel,
                      filename: filename,
                      line: line,
                      funcName: funcName)
    }
    
    /// Tells to all the providers that an event with`LogSeverity.info` has occurred.
    /// If the minimum severity is higher than `.info` or the logging is disabled, the method returns immediatly.
    /// - Parameters:
    ///   - object: The message sent.
    ///   - filename: The name of the file from where it is getting called.
    ///   - funcName: The method name from which it is getting called.
    ///   - line: The line from where it's getting called.
    public func info(_ object: @autoclosure @escaping Dump,
                     channel: String? = nil,
                     filename: String = #file,
                     funcName: String = #function,
                     line: Int = #line) {
        
        evaluate(severity: .info,
                 object,
                 channel: channel ?? Self.defaultChannel,
                 filename: LogService.fileName(filePath: filename),
                 line: line,
                 funcName: funcName)
    }
    
    /// Tells to all the providers that an event with`LogSeverity.debug` has occurred.
    /// If the minimum severity is higher than `.debug` or the logging is disabled, the method returns immediatly.
    /// - Parameters:
    ///   - object: The message sent.
    ///   - filename: The name of the file from where it is getting called.
    ///   - funcName: The method name from which it is getting called.
    ///   - line: The line from where it's getting called.
    public func debug(_ object: @autoclosure @escaping Dump,
                      channel: String? = nil,
                      filename: String = #file,
                      line: Int = #line,
                      funcName: String = #function) {
        
        evaluate(severity: .debug,
                 object,
                 channel: channel ?? Self.defaultChannel,
                 filename: LogService.fileName(filePath: filename),
                 line: line,
                 funcName: funcName)
    }
    
    /// Tells to all the providers that an event with`LogSeverity.verbose` has occurred.
    /// If the minimum severity is higher than `.verbose` or the logging is disabled, the method returns immediatly.
    /// - Parameters:
    ///   - object: The message sent.
    ///   - filename: The name of the file from where it is getting called.
    ///   - funcName: The method name from which it is getting called.
    ///   - line: The line from where it's getting called.
    public func verbose(_ object: @autoclosure @escaping Dump,
                        channel: String? = nil,
                        filename: String = #file,
                        line: Int = #line,
                        funcName: String = #function) {
        
        evaluate(severity: .verbose,
                 object,
                 channel: channel ?? Self.defaultChannel,
                 filename: LogService.fileName(filePath: filename),
                 line: line,
                 funcName: funcName)
    }
    
    /// Tells to all the providers that an event with`LogSeverity.warning` has occurred.
    /// If the minimum severity is higher than `.warning` or the logging is disabled, the method returns immediatly.
    /// - Parameters:
    ///   - object: The message sent.
    ///   - filename: The name of the file from where it is getting called.
    ///   - funcName: The method name from which it is getting called.
    ///   - line: The line from where it's getting called.
    public func warning(_ object: @autoclosure @escaping Dump,
                        channel: String? = nil,
                        filename: String = #file,
                        line: Int = #line,
                        funcName: String = #function) {
        
        evaluate(severity: .warning,
                 object,
                 channel: channel ?? Self.defaultChannel,
                 filename: LogService.fileName(filePath: filename),
                 line: line,
                 funcName: funcName)
    }
    
    /// Tells to all the providers that an event with`LogSeverity.error` has occurred.
    /// If the minimum severity is higher than `.error` or the logging is disabled, the method returns immediatly.
    /// - Parameters:
    ///   - object: The message sent.
    ///   - filename: The name of the file from where it is getting called.
    ///   - funcName: The method name from which it is getting called.
    ///   - line: The line from where it's getting called.
    public func error(_ object: @autoclosure @escaping Dump,
                      channel: String? = nil,
                      filename: String = #file,
                      line: Int = #line,
                      funcName: String = #function) {
        
        evaluate(severity: .error,
                 object,
                 channel: channel ?? Self.defaultChannel,
                 filename: LogService.fileName(filePath: filename),
                 line: line,
                 funcName: funcName)
    }
    
    private func evaluate(severity: LogSeverity,
                          _ object: @autoclosure Dump,
                          channel: String,
                          filename: String = #file,
                          line: Int = #line,
                          funcName: String = #function) {
        
        guard minimumSeverity <= severity, enabled else {
            return
        }
        
        #if !DEBUG
        if severity == .debugOnly { return }
        #endif
        
        var threadID: UInt64 = 0
        pthread_threadid_np(nil, &threadID)
        
        let obj: Any
        if let dumpObj = object() as? Dump {
            obj = dumpObj()
        } else {
            obj = object()
        }
        
        let logMessage = LoggedMessage(payload: String(describing: obj),
                                   severity: severity,
                                   callingFilePath: filename,
                                   callingFileLine: line,
                                   callingStackFrame: funcName,
                                   callingThreadID: threadID,
                                   channel: channel)
        propagate(logMessage)
    }
    
    /// Propagates the log to all the registered providers.
    private func propagate(_ logMessage: LoggedMessage) {
        
        LogService.providers.forEach {
            $0.log(logMessage)
        }
    }
    
    /// Extracts the filename from the filepath.
    private static func fileName(filePath: String) -> String {
        
        let components = filePath.components(separatedBy: "/")
        return components.isEmpty ? "" : components.last!
    }
}
