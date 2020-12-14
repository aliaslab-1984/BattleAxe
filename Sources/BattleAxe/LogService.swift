import Foundation

/// This is the main class, this will let you log from everywhere into your app/framework.
/// In order to log something just use the shared instance and choose a log level, the LogService will take care for propagating the log to your providers.
public final class LogService {
    
    private static var providers = [LogProvider]()
    
    static let shared = LogService(providers: providers)
    
    var minimumSeverity: LogSeverity = .debug
    var configuration: LoggerConfiguration = .standard
    
    private init(providers: [LogProvider]) {
        LogService.providers = providers
    }
    
    static func register(provider: LogProvider) {
        providers.append(provider)
    }
    
    func info(_ object: Any,
              filename: String = #file,
              funcName: String = #function,
              line: Int = #line) {
        
        guard minimumSeverity >= .info  else {
            return
        }
        
        propagate(object,
                  .info,
                  filename: LogService.fileName(filePath: filename),
                  line: line,
                  funcName: funcName)
    }
    
    func debug(_ object: Any,
               filename: String = #file,
               line: Int = #line,
               funcName: String = #function) {
        
        guard minimumSeverity >= .debug  else {
            return
        }
        
        propagate(object,
                  .debug,
                  filename: LogService.fileName(filePath: filename),
                  line: line,
                  funcName: funcName)
    }
    
    func verbose(_ object: Any,
                 filename: String = #file,
                 line: Int = #line,
                 funcName: String = #function) {
        
        guard minimumSeverity >= .verbose  else {
            return
        }
        
        propagate(object,
                  .verbose,
                  filename: LogService.fileName(filePath: filename),
                  line: line,
                  funcName: funcName)
    }
    
    func warning(_ object: Any,
                 filename: String = #file,
                 line: Int = #line,
                 funcName: String = #function) {
        
        guard minimumSeverity >= .warning  else {
            return
        }
        
        propagate(object,
                  .warning,
                  filename: LogService.fileName(filePath: filename),
                  line: line,
                  funcName: funcName)
    }
    
    func error(_ object: Any,
               filename: String = #file,
               line: Int = #line,
               funcName: String = #function) {
        
        guard minimumSeverity >= .error  else {
            return
        }
        
        propagate(object,
                  .error,
                  filename: LogService.fileName(filePath: filename),
                  line: line,
                  funcName: funcName)
    }
    
    private func propagate(_ object: Any,
                           _ severity: LogSeverity,
                           filename: String = #file,
                           line: Int = #line,
                           funcName: String = #function) {
        LogService.providers.forEach {
            $0.log(severity, message: ("\(object)"), file: LogService.fileName(filePath: filename), function: funcName, line: line)
        }
    }
    
    private static func fileName(filePath: String) -> String {
        let components = filePath.components(separatedBy: "/")
        return components.isEmpty ? "" : components.last!
    }
}
