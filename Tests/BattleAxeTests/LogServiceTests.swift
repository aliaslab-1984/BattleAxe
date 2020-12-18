//
//  LogServiceTests.swift
//  
//
//  Created by Francesco Bianco on 17/12/2020.
//

@testable import BattleAxe
import XCTest

final class LogServiceTests: XCTestCase {
    
    func testBaseLogging() {
        let message = "Ciao"
        let fileWriter = MockFileWriter(filename: "", appGroup: nil, fileManager: .default)
        let handler = MockFileLogProvider(dateFormatter: DateFormatter(), fileWriter: fileWriter)
        LogService.register(provider: handler)
        LogService.shared.debug(message)
        
        XCTAssert(fileWriter.lastPrintedMessage == message)
    }
    
    func testLogDisabled() {
        let message = "Ciao"
        let fileWriter = MockFileWriter(filename: "", appGroup: nil, fileManager: .default)
        let handler = MockFileLogProvider(dateFormatter: DateFormatter(), fileWriter: fileWriter)
        LogService.register(provider: handler)
        LogService.shared.enabled = false
        LogService.shared.debug(message)
        
        XCTAssert(fileWriter.lastPrintedMessage == nil)
    }
    
    func testLogBelowMinimumLevel() {
        let message = "Ciao"
        let fileWriter = MockFileWriter(filename: "", appGroup: nil, fileManager: .default)
        let handler = MockFileLogProvider(dateFormatter: DateFormatter(), fileWriter: fileWriter)
        LogService.register(provider: handler)
        LogService.shared.minimumSeverity = .warning
        LogService.shared.debug(message)
        
        XCTAssert(fileWriter.lastPrintedMessage == nil)
    }
    
    static var allTests = [
        ("testBaseLogging", testBaseLogging),
        ("testLogDisabled", testLogDisabled),
        ("testLogBelowMinimumLevel", testLogBelowMinimumLevel)
    ]
}
