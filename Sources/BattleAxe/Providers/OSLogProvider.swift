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
    
    private var dateFormatter: DateFormatter
    private var subsystem: String
    
    public init(dateFormatter: DateFormatter,
                subsystem: String = "") {
        self.dateFormatter = dateFormatter
        self.subsystem = subsystem
    }
    
    public func log(_ severity: LogSeverity,
                    message: String,
                    file: String,
                    function: String,
                    line: Int) {
        let log = OSLog(subsystem: self.subsystem, category: "BattleAxe")
        let type = severity.toOSLogLevel()
        os_log("%{public}@", log: log, type: type, severity.emoji + " " + message)
    }
    
}
