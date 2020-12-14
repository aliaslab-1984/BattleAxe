//
//  ExternalLogHandler.swift
//  
//
//  Created by Francesco Bianco on 14/12/2020.
//

import Foundation

/// If you want to just listen logs you need to conform to this .
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
    
    private weak var listener: LogListener? = nil
    
    public func log(_ severity: LogSeverity, message: String, file: String, function: String, line: Int) {
        listener?.log(severity, message: message)
    }
    
}
