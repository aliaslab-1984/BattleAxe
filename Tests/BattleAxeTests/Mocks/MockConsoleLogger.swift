//
//  File.swift
//  
//
//  Created by Francesco Bianco on 14/04/21.
//

import Foundation
import BattleAxe

final class MockConsoleLogger: LogProvider {
    public var channels: Set<String> = .init([LogService.defaultChannel])
    
    var logIdentifier: String = "MockConsole Logger"
    var lastMessage: LogMessage? = nil
    
    
    public func log(_ message: LogMessage) {
        
        guard !channels.isEmpty else {
            lastMessage = message
            return
        }
        
        if channels.contains(message.channel) {
            lastMessage = message
        }
    }
    
}
