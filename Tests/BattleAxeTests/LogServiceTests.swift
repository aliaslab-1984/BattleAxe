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
        let dateFormatter = DateFormatter()
        let fileWriter = MockFileWriter(.defaultConfig(name: "", queueName: "MockQueue"))
        let handler = MockFileLogProvider(dateFormatter: dateFormatter, fileWriter: fileWriter)
        let oslog = OSLogProvider(dateFormatter: dateFormatter)
        LogService.shared.minimumSeverity = .debug
        LogService.register(provider: handler)
        LogService.register(provider: oslog)
        LogService.shared.debug(message)
        
        XCTAssertNotNil(fileWriter.lastPrintedMessage)
        XCTAssertEqual(fileWriter.lastPrintedMessage, message)
        
        LogService.shared.log(.debug, message)
        XCTAssertNotNil(fileWriter.lastPrintedMessage)
        XCTAssertEqual(fileWriter.lastPrintedMessage, message)
    }
    
    func testLogDebug() {
        let message = "Ciao"
        let listener = MockConsoleLogger()
        LogService.shared.enabled = true
        LogService.register(provider: listener)
        LogService.shared.ifDebug(.debug, message)
        
        #if !DEBUG
        XCTAssertNil(listener.lastMessage)
        #else
        XCTAssertNotNil(listener.lastMessage)
        #endif
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
    
    func testExternalLogProvider() {
        let message = "Ciao"
        let externalHandler = ExternalLogHandler()
        let listener = MockListener()
        externalHandler.setListener(listener: listener)
        LogService.register(provider: externalHandler)
        LogService.shared.minimumSeverity = .info
        let cases = LogSeverity.allCases
        cases.forEach { (severity) in
            LogService.shared.log(severity, message)
        }
        
        XCTAssertNotNil(listener.lastMessage)
    }
    
    static var allTests = [
        //("testBaseLogging", testBaseLogging),
        ("testLogDisabled", testLogDisabled),
        ("testLogBelowMinimumLevel", testLogBelowMinimumLevel),
        ("testLogBelowMinimumLevelLog", testLogBelowMinimumLevelLog),
        ("testallLogsSeverityWithLog", testallLogsSeverityWithLog),
        ("testExternalLogProvider", testExternalLogProvider),
        ("testLogDebug", testLogDebug)
    ]
}
