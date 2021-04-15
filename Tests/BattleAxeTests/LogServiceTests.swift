//
//  LogServiceTests.swift
//  
//
//  Created by Francesco Bianco on 17/12/2020.
//

@testable import BattleAxe
import XCTest

final class LogServiceTests: XCTestCase {
    
    override func setUp() {
        LogService.empty()
    }
    
    func testBaseLogging() {
        let message = "Ciao"
        let dateFormatter = DateFormatter()
        let fileWriter = MockFileWriter(.defaultConfig(name: "", queueName: "MockQueue"))
        let handler = MockFileLogProvider(dateFormatter: dateFormatter, fileWriter: fileWriter)
        let oslog = OSLogProvider(dateFormatter: dateFormatter)
        LogService.shared.minimumSeverity = .verbose
        LogService.register(provider: handler)
        LogService.register(provider: oslog)
        LogService.shared.debug(message)
        
        XCTAssertNotNil(fileWriter.lastPrintedMessage)
        XCTAssertEqual(fileWriter.lastPrintedMessage, message)
        
        LogService.shared.log(.debug, message)
        XCTAssertNotNil(fileWriter.lastPrintedMessage)
        XCTAssertEqual(fileWriter.lastPrintedMessage, message)
    }
    
    func testAllSeveritiesLogging() {
        let message = "Ciao"
        let dateFormatter = DateFormatter()
        let fileWriter = MockFileWriter(.defaultConfig(name: "", queueName: "MockQueue"))
        let handler = MockFileLogProvider(dateFormatter: dateFormatter, fileWriter: fileWriter)
        let oslog = OSLogProvider(dateFormatter: dateFormatter)
        LogService.shared.minimumSeverity = .verbose
        LogService.register(provider: handler)
        LogService.register(provider: oslog)
        
        LogSeverity.allCases.forEach { (severity) in
            LogService.shared.log(severity, message)
        }
        
        XCTAssertNotNil(fileWriter.lastPrintedMessage)
        XCTAssertEqual(fileWriter.lastPrintedMessage, message)
    }
    
    func testAllLoggingShortcuts() {
        let message = "Ciao"
        let dateFormatter = DateFormatter()
        let fileWriter = MockFileWriter(.defaultConfig(name: "", queueName: "MockQueue"))
        let handler = MockFileLogProvider(dateFormatter: dateFormatter, fileWriter: fileWriter)
        let oslog = OSLogProvider(dateFormatter: dateFormatter)
        LogService.shared.minimumSeverity = .verbose
        LogService.register(provider: handler)
        LogService.register(provider: oslog)
        
        LogSeverity.allCases.forEach { (severity) in
            switch severity {
            case .debug:
                LogService.shared.debug(message)
            case .error:
                LogService.shared.error(message)
            case .verbose:
                LogService.shared.verbose(message)
            case .info:
                LogService.shared.info(message)
            case .warning:
                LogService.shared.warning(message)
            }
            XCTAssertNotNil(fileWriter.lastPrintedMessage)
            XCTAssertEqual(fileWriter.lastPrintedMessage, message)
        }
    }
    
    func testLogDebug() {
        let listener = MockConsoleLogger()
        listener.lastMessage = nil
        LogService.shared.enabled = true
        LogService.empty()
        LogService.register(provider: listener)
        LogService.shared.ifDebug(.debug, self.expectedIntMessage())
        
        #if DEBUG
          XCTAssertNotNil(listener.lastMessage)
        #else
          XCTAssertNil(listener.lastMessage)
        #endif
    }
    
    func expectedIntMessage() -> Int {
        return 23
    }
    
    func testEmptyProviders() {
        LogService.empty()
        XCTAssert(LogService.currentProviders.isEmpty)
    }
    
    func testRemoveProvider() {
        LogService.empty()
        let listener = MockConsoleLogger()
        listener.logIdentifier = "Chris"
        
        LogService.register(provider: listener)
        
        XCTAssert(LogService.currentProviders.count == 1)
        
        let secondListener = MockConsoleLogger()
        secondListener.logIdentifier = "Martin"
        LogService.unregister(provider: secondListener)
        
        XCTAssert(LogService.currentProviders.count == 1)
        
        LogService.unregister(provider: listener)
        
        XCTAssert(LogService.currentProviders.isEmpty)
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
        ("testBaseLogging", testBaseLogging),
        ("testLogDisabled", testLogDisabled),
        ("testLogBelowMinimumLevel", testLogBelowMinimumLevel),
        ("testLogBelowMinimumLevelLog", testLogBelowMinimumLevelLog),
        ("testallLogsSeverityWithLog", testallLogsSeverityWithLog),
        ("testExternalLogProvider", testExternalLogProvider),
        ("testLogDebug", testLogDebug),
        ("testEmptyProviders", testEmptyProviders),
        ("testRemoveProvider", testRemoveProvider),
        ("testAllSeveritiesLogging", testAllSeveritiesLogging),
        ("testAllLoggingShortcuts", testAllLoggingShortcuts)
    ]
}
