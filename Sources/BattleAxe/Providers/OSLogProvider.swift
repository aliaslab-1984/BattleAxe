//
//  OSLogProvider.swift
//  
//
//  Created by Francesco Bianco on 11/12/2020.
//

import Foundation
import os.log

public struct OSLogProvider: LogProvider {
    
    private var dateFormatter: DateFormatter
    
    public init(dateFormatter: DateFormatter) {
        self.dateFormatter = dateFormatter
    }
    
    public func log(_ severity: LogSeverity,
                    message: String,
                    file: String,
                    function: String,
                    line: Int) {
        // TODO: Need to take a closer look to this one.
        //os_log(event.toOSLogLevel(), message)
    }
    
}
