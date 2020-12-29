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
    
    init(filename: String,
         appGroup: String?,
         rotationConfiguration: RotatorConfiguration = .none,
         fileManager: BAFileManager,
         fileSeeker: BAFileSeeker = BAFileAppender(fileSystemController: FileManager.default)) {
        self.rotationConfiguration = rotationConfiguration
    }
    
    func write(_ message: String) {
        lastPrintedMessage = message
    }
    
    func deleteLogs() {
        
    }
    
}
