//
//  MockFileWriter.swift
//  
//
//  Created by Francesco Bianco on 17/12/2020.
//

import Foundation
import BattleAxe

final class MockFileWriter: FileWriter {
    
    var rotationConfiguration: RotatorConfiguration
    var lastPrintedMessage: String?
    
    init(_ configuration: FileWriterConfiguration) {
        self.rotationConfiguration = configuration.rotationConfiguration
    }
    
    func write(_ message: String) {
        lastPrintedMessage = message
    }
    
    func deleteLogs() {
        
    }
    
}
