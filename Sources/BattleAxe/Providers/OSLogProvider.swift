//
//  OSLogProvider.swift
//  
//
//  Created by Francesco Bianco on 11/12/2020.
//

import Foundation
import os.log

@available(iOS 10.0, macOS 10.12, tvOS 10.0, watchOS 3.0, *)
public final class OSLogProvider: LogProvider {
    
    public var logIdentifier: String
    
    private var dateFormatter: DateFormatter
    public var channels: Set<String> = .init([LogService.defaultChannel])
    public var subsystem: String
    
    public init(dateFormatter: DateFormatter,
                subsystem: String = "",
                identifier: String = "Default OSLogIdentifier") {
        self.dateFormatter = dateFormatter
        self.subsystem = subsystem
        self.logIdentifier = identifier
    }
    
    public func log(_ message: LogMessage) {
        guard !channels.isEmpty else {
            writeLog(with: message)
            return
        }
        
        if channels.contains(message.channel) {
            writeLog(with: message)
        }
    }
    
    public func addChannel(_ channel: String) {
        channels.insert(channel)
    }
    
    public func removeChannel(_ channel: String) {
        channels.remove(channel)
    }
    
    private func writeLog(with message: LogMessage) {
        let log = OSLog(subsystem: self.subsystem, category: message.channel)
        let type = message.severity.toOSLogLevel()
        os_log("%{public}@", log: log, type: type, message.severity.emoji + " " + message.payload)
    }
    
}
