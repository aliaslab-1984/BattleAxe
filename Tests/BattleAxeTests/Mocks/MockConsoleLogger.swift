//
//  File.swift
//  
//
//  Created by Francesco Bianco on 14/04/21.
//

import Foundation
import BattleAxe

final class MockConsoleLogger: LogProvider {
    var logIdentifier: String = "MockConsole Logger"
    
    func log(_ message: LogMessage) {
        lastMessage = message
    }
    
    var lastMessage: LogMessage? = nil
    
}