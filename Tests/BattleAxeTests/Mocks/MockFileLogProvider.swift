//
//  MockFileLogProvider.swift
//  
//
//  Created by Francesco Bianco on 17/12/2020.
//

import Foundation
import BattleAxe

final class MockFileLogProvider: LogProvider {
    
    public var channels: Set<String> = .init([LogService.defaultChannel])
    
    private var dateFormatter: DateFormatter
    private var fileWriter: FileWriter
    public var logIdentifier: String = "Mock FileLogProvider"
    
    public init(dateFormatter: DateFormatter, fileWriter: FileWriter) {
        self.dateFormatter = dateFormatter
        self.fileWriter = fileWriter
    }
    
    func log(_ message: LogMessage) {
        fileWriter.write(message.payload + " " + message.severity.prettyDescription)
    }
    
    func addChannel(_ channel: String) {
        channels.insert(channel)
    }
    
    func removeChannel(_ channel: String) {
        channels.remove(channel)
    }
    
}
