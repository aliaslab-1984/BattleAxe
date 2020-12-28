import Foundation

/// This is the main class, this will let you log from everywhere into your app/framework.
/// In order to log something just use the shared instance and choose a log level, the LogService will take care for propagating the log to your providers.
public final class LogService {
    
    private static var providers = [LogProvider]()
    
    public static let shared = LogService(providers: providers)
    
    public var minimumSeverity: LogSeverity = .debug
    public var configuration: LoggerConfiguration = .standard
    public var enabled: Bool = true
    
    private init(providers: [LogProvider]) {
        LogService.providers = providers
    }
    
    /// Adds a new LogProvider object to the list.
    public static func register(provider: LogProvider) {
        providers.append(provider)
    }
    
    /// Convenience method. It calls verbose(), debug() ... depending on the `LogSeverity` specified at the begining.
    /// - Parameters:
    ///   - severity: The log's severity.
    ///   - object: The message that should be displayed.
    ///   - filename: The filename
    ///   - funcName: The method name.
    ///   - line: The file's line.
    public func log(_ severity: LogSeverity,
                    _ object: Any,
                    filename: String = #file,
                    funcName: String = #function,
                    line: Int = #line) {
        switch severity {
        case .verbose:
            self.verbose(object,
                         filename: filename,
                         line: line,
                         funcName: funcName)
        case .debug:
            self.debug(object,
                         filename: filename,
                         line: line,
                         funcName: funcName)
        case .info:
            self.info(object,
                         filename: filename,
                         funcName: funcName,
                         line: line)
        case .warning:
            self.warning(object,
                         filename: filename,
                         line: line,
                         funcName: funcName)
        case .error:
            self.error(object,
                       filename: filename,
                       line: line,
                       funcName: funcName)
        }
    }
    
    public func info(_ object: Any,
              filename: String = #file,
              funcName: String = #function,
              line: Int = #line) {
        
        guard minimumSeverity <= .info, enabled else {
            return
        }
        
        propagate(object,
                  .info,
                  filename: LogService.fileName(filePath: filename),
                  line: line,
                  funcName: funcName)
    }
    
    public func debug(_ object: Any,
               filename: String = #file,
               line: Int = #line,
               funcName: String = #function) {
        
        guard minimumSeverity <= .debug, enabled  else {
            return
        }
        
        propagate(object,
                  .debug,
                  filename: LogService.fileName(filePath: filename),
                  line: line,
                  funcName: funcName)
    }
    
    public func verbose(_ object: Any,
                 filename: String = #file,
                 line: Int = #line,
                 funcName: String = #function) {
        
        guard minimumSeverity <= .verbose, enabled  else {
            return
        }
        
        propagate(object,
                  .verbose,
                  filename: LogService.fileName(filePath: filename),
                  line: line,
                  funcName: funcName)
    }
    
    public func warning(_ object: Any,
                 filename: String = #file,
                 line: Int = #line,
                 funcName: String = #function) {
        
        guard minimumSeverity <= .warning, enabled  else {
            return
        }
        
        propagate(object,
                  .warning,
                  filename: LogService.fileName(filePath: filename),
                  line: line,
                  funcName: funcName)
    }
    
    public func error(_ object: Any,
               filename: String = #file,
               line: Int = #line,
               funcName: String = #function) {
        
        guard minimumSeverity <= .error, enabled  else {
            return
        }
        
        propagate(object,
                  .error,
                  filename: LogService.fileName(filePath: filename),
                  line: line,
                  funcName: funcName)
    }
    
    /// Propagates the log to all the registered providers.
    private func propagate(_ object: Any,
                           _ severity: LogSeverity,
                           filename: String = #file,
                           line: Int = #line,
                           funcName: String = #function) {
        LogService.providers.forEach {
            $0.log(severity, message: ("\(object)"), file: LogService.fileName(filePath: filename), function: funcName, line: line)
        }
    }
    
    /// Extracts the filename from the filepath.
    private static func fileName(filePath: String) -> String {
        let components = filePath.components(separatedBy: "/")
        return components.isEmpty ? "" : components.last!
    }
}
