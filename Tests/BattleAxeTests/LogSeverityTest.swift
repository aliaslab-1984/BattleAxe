//
//  LogSeverityTest.swift
//  
//
//  Created by Francesco Bianco on 17/12/2020.
//

@testable import BattleAxe
import XCTest

final class LogSeverityTest: XCTestCase {
    
    func testToOsLogGetter() {
        let severities = LogSeverity.allCases
        
        for severity in severities {
            switch severity {
            case .info:
                XCTAssert(severity.toOSLogLevel() == .info)
            case .verbose:
                XCTAssert(severity.toOSLogLevel() == .default)
            case .debug:
                XCTAssert(severity.toOSLogLevel() == .debug)
            case .warning:
                XCTAssert(severity.toOSLogLevel() == .fault)
            case .error:
                XCTAssert(severity.toOSLogLevel() == .error)
            }
        }
    }
    
    func testDescriptionGetter() {
        let severities = LogSeverity.allCases
        
        for severity in severities {
            switch severity {
            case .info:
                XCTAssert(severity.description == "Info")
            case .verbose:
                XCTAssert(severity.description == "Verbose")
            case .debug:
                XCTAssert(severity.description == "Debug")
            case .warning:
                XCTAssert(severity.description == "Warning")
            case .error:
                XCTAssert(severity.description == "Error")
            }
        }
    }
    
    func testEmojiLogs() {
        let severities = LogSeverity.allCases
        
        for severity in severities {
            switch severity {
            case .info:
                XCTAssert(severity.emoji == "ℹ️")
            case .verbose:
                XCTAssert(severity.emoji == "📗")
            case .debug:
                XCTAssert(severity.emoji == "🔨")
            case .warning:
                XCTAssert(severity.emoji == "⚠️")
            case .error:
                XCTAssert(severity.emoji == "💥")
            }
        }
    }
    
    func testLogSeverityValue() {
        XCTAssert(LogSeverity.debug < LogSeverity.warning)
        XCTAssert(LogSeverity.error > LogSeverity.warning)
    }
 
    static var allTests = [
        ("testToOsLogGetter", testToOsLogGetter),
        ("testDescriptionGetter", testDescriptionGetter),
        ("testEmojiLogs", testEmojiLogs),
        ("testLogSeverityValue", testLogSeverityValue)
    ]
}
