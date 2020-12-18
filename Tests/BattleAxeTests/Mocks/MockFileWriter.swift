//
//  MockFileWriter.swift
//  
//
//  Created by Francesco Bianco on 17/12/2020.
//

import Foundation
import BattleAxe

final class MockFileWriter: FileWriter {
    
    var rotationConfiguration: RotatorConfiguration = .none
    
    var lastPrintedMessage: String?
    
    func write(_ message: String) {
        lastPrintedMessage = message
    }
    
    func deleteLogs() {
        
    }
    
}
