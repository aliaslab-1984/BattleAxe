//
//  OSLogProvider.swift
//  
//
//  Created by Francesco Bianco on 11/12/2020.
//

import Foundation
import os.log

@available(iOS 10.0, macOS 10.12, tvOS 10.0, watchOS 3.0, *)
public struct OSLogProvider: LogProvider {
    
    public var logIdentifier: String
    
    private var dateFormatter: DateFormatter
    private var subsystem: String
    
    public init(dateFormatter: DateFormatter,
                subsystem: String = "",
                identifier: String = "Default OSLogIdentifier") {
        self.dateFormatter = dateFormatter
        self.subsystem = subsystem
        self.logIdentifier = identifier
    }
    
    public func log(_ message: LogMessage) {
        let log = OSLog(subsystem: self.subsystem, category: "BattleAxe")
        let type = message.severity.toOSLogLevel()
        os_log("%{public}@", log: log, type: type, message.severity.emoji + " " + message.payload)
    }
    
}
