//
//  ExternalLogHandler.swift
//  
//
//  Created by Francesco Bianco on 14/12/2020.
//

import Foundation

/// Listen to any new log externally from the SDK.
public protocol LogListener: AnyObject {
    
    /// Passes the logs from an external module to a LogListener
    /// - Parameters:
    ///   - severity: The log's severity.
    ///   - message: The message attached to the log.
    func log(_ severity: LogSeverity, message: String)
    
}

/// This class handles an external hand ler.
/// Example: you want to hook logs from an SDK to an implementing app.
/// In this case, the app decides what to do with logs.
public class ExternalLogHandler: LogProvider {
    
    public var channels: Set<String> = .init([LogService.defaultChannel])
    
    public var logIdentifier: String = "External Log Handler Identifier"
    
    private weak var listener: LogListener? = nil
    
    func setListener(listener: LogListener?) {
        self.listener = listener
    }
    
    public func log(_ message: LogMessage) {
        
        guard !channels.isEmpty else {
            listener?.log(message.severity, message: message.payload)
            return
        }
        
        if channels.contains(message.channel) {
            listener?.log(message.severity, message: message.payload)
        }
        
    }
    
    public func addChannel(_ channel: String) {
        channels.insert(channel)
    }
    
    public func removeChannel(_ channel: String) {
        channels.remove(channel)
    }
}
