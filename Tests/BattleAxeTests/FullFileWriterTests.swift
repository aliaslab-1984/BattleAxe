//
//  FullFileWriterTests.swift
//  
//
//  Created by Francesco Bianco on 29/12/2020.
//

import XCTest
@testable import BattleAxe

final class FullFileWriterTests: XCTestCase {
    
    func testExample() {
        let files: [MockedFileManager.MockFile] = [
            .init(path: "This/IS/a/path/logs.logs", bytes: 10.kiloBytes)
        ]
        let mockFileController = MockedFileManager(files: .init(files))
        let mockManager = BAFileManager(folderName: "Logs", fileManager: mockFileController)
        
        let configuration = FileWriterConfiguration(filename: "myFile", appGroup: nil, queueName: "StandardLogFileWriter", rotationConfiguration: .standard, fileManager: mockManager, fileSeeker: BAFileController(fileSystemController: mockFileController))
        let fileWriter = StandardLogFileWriter(configuration)
        
        fileWriter.write("Hello")
        
        XCTAssert(true)
    }
    
//    func testDeletion() {
//        let files: [MockedFileManager.MockFile] = [
//            .init(path: "~/Logs/logs.logs", bytes: 10.kiloBytes)
//        ]
//        let mockFileController = MockedFileManager(files: .init(files))
//        let mockManager = BAFileManager(folderName: "Logs", fileManager: mockFileController)
//
//        let configuration = FileWriterConfiguration(filename: "logos", appGroup: nil, queueName: "StandardLogFileWriter", rotationConfiguration: .standard, fileManager: mockManager, fileSeeker: BAFileController(fileSystemController: mockFileController))
//        let fileWriter = StandardLogFileWriter(configuration)
//        fileWriter.deleteLogs()
//
//        XCTAssert(mockFileController.files.isEmpty)
//    }
    
    func testPerformances() {
        
        let mockManager = BAFileManager(folderName: "Logs", fileManager: FileManager.default)
        
        let configuration = FileWriterConfiguration(filename: "myFile", appGroup: nil, queueName: "StandardLogFileWriter", rotationConfiguration: .standard, fileManager: mockManager, fileSeeker: BAFileController(fileSystemController: FileManager.default))
        let fileWriter = StandardLogFileWriter(configuration)
        
        measure {
            fileWriter.write("Hello")
        }
        
    }
    
    func testDefaultPerformances() {
        
        let mockManager = BAFileManager(folderName: "Logs", fileManager: FileManager.default)
        
        let configuration = FileWriterConfiguration(filename: "myFile", appGroup: nil, queueName: "StandardLogFileWriter", rotationConfiguration: .none, fileManager: mockManager, fileSeeker: BAFileController(fileSystemController: FileManager.default))
        let fileWriter = StandardLogFileWriter(configuration)
        
        measure {
            fileWriter.write("Hello")
        }
    }
    
    func testBriefFileWriterPerformances() {
        
        let mockManager = BAFileManager(folderName: "Logs", fileManager: FileManager.default)
        
        let configuration = FileWriterConfiguration(filename: "myFile", appGroup: nil, queueName: "StandardLogFileWriter", rotationConfiguration: .none, fileManager: mockManager, fileSeeker: BAFileController(fileSystemController: FileManager.default))
        let fileWriter = BriefLogFileWriter(configuration)
        
        measure {
            fileWriter.write("Hello")
        }
    }
    
    func testConsoleLogPerformances() {
        
        LogService.empty()
        LogService.register(provider: ConsoleLogProvider(dateFormatter: LogDateFormatter()))
        LogService.shared.minimumSeverity = .verbose
        measure {
            LogService.shared.debug("Hello")
        }
    }
    
    func testOSLogPerformances() {
        
        LogService.empty()
        LogService.register(provider: OSLogProvider(dateFormatter: LogDateFormatter()))
        LogService.shared.minimumSeverity = .verbose
        measure {
            LogService.shared.debug("Hello")
        }
    }
    
    func testMultipleProviderPerformances() {
        
        let mockManager = BAFileManager(folderName: "Logs", fileManager: FileManager.default)
        
        let configuration = FileWriterConfiguration(filename: "myFile", appGroup: nil, queueName: "StandardLogFileWriter", rotationConfiguration: .standard, fileManager: mockManager, fileSeeker: BAFileController(fileSystemController: FileManager.default))
        let fileWriter = StandardLogFileWriter(configuration)
        
        LogService.empty()
        LogService.register(provider: OSLogProvider(dateFormatter: LogDateFormatter()))
        LogService.register(provider: ConsoleLogProvider(dateFormatter: LogDateFormatter()))
        LogService.register(provider: FileLogProvider(dateFormatter: LogDateFormatter(), fileWriter: fileWriter))
        LogService.shared.minimumSeverity = .verbose
        measure {
            LogService.shared.debug("Hello")
        }
    }
    
    func testFileLogProvoder() {
        
        let mockManager = BAFileManager(folderName: "Logs", fileManager: FileManager.default)
        
        let configuration = FileWriterConfiguration(filename: "myFile", appGroup: nil, queueName: "StandardLogFileWriter", rotationConfiguration: .none, fileManager: mockManager, fileSeeker: BAFileController(fileSystemController: FileManager.default))
        let fileWriter = MockFileWriter(configuration)
        let formatter = LogDateFormatter(dateFormat: "yyyy-MM-dd")
        let logprovider = FileLogProvider(dateFormatter: formatter, fileWriter: fileWriter, configuration: .naive)
        
        let message = "Ciao"
        let expectedFunc = "function"
        let expectedFile = "file"
        let line = 44
        let channel = "Additional Channel"
        logprovider.addChannel(channel)
        
        logprovider.log(.debug, message: message, file: expectedFile, function: expectedFunc, line: line, channel: channel)
        
        XCTAssertNotNil(fileWriter.lastPrintedMessage)
        
        if let lastMessage = fileWriter.lastPrintedMessage {
            XCTAssert(lastMessage == "{\(channel)} [\(LogSeverity.debug.prettyDescription)]  🔈💬\(message)")
        } else {
            XCTFail("The message is nil")
        }
        
        logprovider.removeChannel(channel)
        logprovider.log(.debug, message: message, file: expectedFile, function: expectedFunc, line: line, channel: nil)
        
        XCTAssertNotNil(fileWriter.lastPrintedMessage)
        
        if let lastMessage = fileWriter.lastPrintedMessage {
            XCTAssert(lastMessage == "{\(LogService.defaultChannel)} [\(LogSeverity.debug.prettyDescription)]  🔈💬\(message)")
        } else {
            XCTFail("The message is nil")
        }
    }
    
    func testLogComposer() {
        let message = "Ciao"
        let file = "myFile"
        let function = "myFunction"
        let fileLine = 1
        let severity = LogSeverity.error
        let data = Date()
        let formatter = LogDateFormatter(dateFormat: "yyyy-MM-dd")
        let loggedMessage = LogMessageFormatter.compose(LoggedMessage(callingThread: "MyThread", processId: 4, payload: message, severity: severity, callingFilePath: file, callingFileLine: fileLine, callingStackFrame: function, callingThreadID: 4, channel: LogService.defaultChannel, timestamp: data), using: LoggerConfiguration.naive.ingredients.sorted(), dateFormatter: formatter)
        
        let expectedMessage = "{\(LogService.defaultChannel)} [\(LogSeverity.error.prettyDescription)]  🔈💬\(message)"
        
        XCTAssertEqual(loggedMessage, expectedMessage)
    }
    
    private func getCurrentDateString() -> String {
        let currentDate = Date()
        let calendar = Calendar.current
        let year = calendar.component(.year, from: currentDate)
        let month = calendar.component(.month, from: currentDate)
        let day = calendar.component(.day, from: currentDate)
        
        let stringMonth: String
        if month < 10 {
            stringMonth = "0\(month)"
        } else {
            stringMonth = "\(month)"
        }
        
        let stringDay: String
        if day < 10 {
            stringDay = "0\(day)"
        } else {
            stringDay = "\(day)"
        }
        
        return "\(year)-\(stringMonth)-\(stringDay)"
    }
    
    static var allTests = [
        ("testExample", testExample),
        ("testPerformances", testPerformances),
        ("testDefaultPerformances", testDefaultPerformances),
        ("testFileLogProvoder", testFileLogProvoder),
        ("testBriefFileWriterPerformances", testBriefFileWriterPerformances),
        ("testOSLogPerformances", testOSLogPerformances),
        ("testConsoleLogPerformances", testConsoleLogPerformances),
        ("testMultipleProviderPerformances", testMultipleProviderPerformances),
        ("testLogComposer", testLogComposer)
        // ("testDeletion", testDeletion)
    ]
    
}
