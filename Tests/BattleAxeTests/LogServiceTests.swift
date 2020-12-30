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
        let fileWriter = MockFileWriter(.defaultConfig(name: "", queueName: "MockQueue"))
        let handler = MockFileLogProvider(dateFormatter: DateFormatter(), fileWriter: fileWriter)
        LogService.shared.minimumSeverity = .debug
        LogService.register(provider: handler)
        LogService.shared.debug(message)
        
        XCTAssertNotNil(fileWriter.lastPrintedMessage)
        XCTAssertEqual(fileWriter.lastPrintedMessage, message)
    }
    
    func testLogDisabled() {
        let message = "Ciao"
        let fileWriter = MockFileWriter(.defaultConfig(name: "", queueName: "MockQueue"))
        let handler = MockFileLogProvider(dateFormatter: DateFormatter(), fileWriter: fileWriter)
        LogService.register(provider: handler)
        LogService.shared.enabled = false
        LogService.shared.debug(message)
        
        XCTAssert(fileWriter.lastPrintedMessage == nil)
    }
    
    func testLogBelowMinimumLevel() {
        let message = "Ciao"
        let fileWriter = MockFileWriter(.defaultConfig(name: "", queueName: "MockQueue"))
        let handler = MockFileLogProvider(dateFormatter: DateFormatter(), fileWriter: fileWriter)
        LogService.register(provider: handler)
        LogService.shared.minimumSeverity = .warning
        LogService.shared.debug(message)
        
        XCTAssert(fileWriter.lastPrintedMessage == nil)
    }
    
    func testLogBelowMinimumLevelLog() {
        let message = "Ciao"
        let fileWriter = MockFileWriter(.defaultConfig(name: "", queueName: "MockQueue"))
        let handler = MockFileLogProvider(dateFormatter: DateFormatter(), fileWriter: fileWriter)
        LogService.register(provider: handler)
        LogService.shared.minimumSeverity = .warning
        LogService.shared.log(.debug, message)
        
        XCTAssert(fileWriter.lastPrintedMessage == nil)
    }
    
    func testallLogsSeverityWithLog() {
        let message = "Ciao"
        let fileWriter = MockFileWriter(.defaultConfig(name: "", queueName: "MockQueue"))
        let handler = MockFileLogProvider(dateFormatter: DateFormatter(), fileWriter: fileWriter)
        LogService.register(provider: handler)
        LogService.shared.minimumSeverity = .info
        let cases = LogSeverity.allCases
        cases.forEach { (severity) in
            LogService.shared.log(severity, message)
        }
        
        XCTAssertNotNil(fileWriter.lastPrintedMessage)
    }
    
    static var allTests = [
        //("testBaseLogging", testBaseLogging),
        ("testLogDisabled", testLogDisabled),
        ("testLogBelowMinimumLevel", testLogBelowMinimumLevel),
        ("testLogBelowMinimumLevelLog", testLogBelowMinimumLevelLog),
        ("testallLogsSeverityWithLog", testallLogsSeverityWithLog)
    ]
}
