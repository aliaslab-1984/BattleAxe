//
//  MockListener.swift
//  
//
//  Created by Francesco Bianco on 05/01/2021.
//

import Foundation
@testable import BattleAxe

final class MockListener: LogListener {
    
    var lastMessage: (LogSeverity, String)? = nil
    
    func log(_ severity: LogSeverity, message: String) {
        lastMessage = (severity, message)
    }
    
}
