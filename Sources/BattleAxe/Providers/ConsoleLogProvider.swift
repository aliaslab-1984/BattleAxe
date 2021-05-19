import Foundation

public final class ConsoleLogProvider: LogProvider {
    
    public var logIdentifier: String
    
    private var dateFormatter: DateFormatter
    public var channels: Set<String> = .init([LogService.defaultChannel])
    private var configuration: LoggerConfiguration
    private var ingredients: [LoggerConfiguration.LogIngredient]
    
    public init(dateFormatter: DateFormatter,
                identifier: String = "ConsoleLog Provider",
                configuration: LoggerConfiguration = LogService.shared.configuration) {
        self.dateFormatter = dateFormatter
        self.logIdentifier = identifier
        self.configuration = configuration
        ingredients = configuration.ingredients.sorted()
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
    
    public func addChannel(_ channel: String) {
        channels.insert(channel)
    }
    
    public func removeChannel(_ channel: String) {
        channels.remove(channel)
    }
    
    private func printLog(_ message: LogMessage) {
        let finalMessage = LogMessageFormatter.compose(message, using: ingredients, dateFormatter: dateFormatter)
        print(finalMessage)
    }
}
