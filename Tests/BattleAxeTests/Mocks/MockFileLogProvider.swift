//
//  MockFileLogProvider.swift
//  
//
//  Created by Francesco Bianco on 17/12/2020.
//

import Foundation
import BattleAxe

final class MockFileLogProvider: LogProvider {
    
    private var dateFormatter: DateFormatter
    private var fileWriter: FileWriter
    
    public init(dateFormatter: DateFormatter, fileWriter: FileWriter) {
        self.dateFormatter = dateFormatter
        self.fileWriter = fileWriter
    }
    
    func log(_ severity: LogSeverity, message: String, file: String, function: String, line: Int) {
        fileWriter.write(message)
    }
    
}