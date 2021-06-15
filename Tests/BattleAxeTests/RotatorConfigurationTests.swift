//
//  File.swift
//  
//
//  Created by Francesco Bianco on 15/12/2020.
//

import XCTest
@testable import BattleAxe

// swiftlint:disable force_try
final class RotatorConfigurationTests: XCTestCase {
    
    func testSizeLimitNotSet() {
        let pendingData = Data(count: 30.kiloBytes)
        let rotator = try! RotatorConfiguration(maxSize: 0, maxAge: 0, maxFiles: 0)
        
        let result = rotator.check("", "", pendingData: pendingData)
        
        XCTAssert(result)
    }
    
    func testEmptyPath() {
        let rotator = try! RotatorConfiguration(maxSize: 30.megaBytes, maxAge: 7.0.daysToSeconds, maxFiles: 4)
        
        let result = rotator.check("", "", pendingData: Data())
        
        XCTAssertFalse(result)
    }
    
    
    func testBelowMaxSize() {
        let pendingData = Data(count: 30.kiloBytes)
        let fileSize = UInt64(780)
        let rotator = try! RotatorConfiguration(maxSize: 50.kiloBytes, maxAge: 0, maxFiles: 1)
        
        let result = rotator.doesItFits(fileSize, pendingData.count)
        
        XCTAssert(result)
    }
    
    func testOverMaxSize() {
        let pendingData = Data(count: 70.kiloBytes)
        let fileSize = UInt64(780)
        let rotator = try! RotatorConfiguration(maxSize: 50.kiloBytes, maxAge: 0, maxFiles: 1)
        
        let result = rotator.doesItFits(fileSize, pendingData.count)
        
        XCTAssertFalse(result)
    }
    
    func testMaxAgeNotSet() {
        let rotator = try! RotatorConfiguration(maxSize: 0, maxAge: 0, maxFiles: 1)
        
        let fakeFileCreationDate = Date().addingTimeInterval(-14.0.daysToSeconds)
        
        let result = rotator.belowMaxAge(fakeFileCreationDate)
        
        XCTAssertFalse(result)
    }
    
    func testOlderCreationDate() {
        let rotator = try! RotatorConfiguration(maxSize: 0, maxAge: 7.0.daysToSeconds, maxFiles: 1)
        
        let fakeFileCreationDate = Date().addingTimeInterval(-14.0.daysToSeconds)
        
        let result = rotator.belowMaxAge(fakeFileCreationDate)
        
        XCTAssertFalse(result)
    }
    
    func testNewerCreationDate() {
        let rotator = try! RotatorConfiguration(maxSize: 0, maxAge: 7.0.daysToSeconds, maxFiles: 1)
        
        let fakeFileCreationDate = Date().addingTimeInterval(-24.0.minutesToSeconds)
        
        let result = rotator.belowMaxAge(fakeFileCreationDate)
        
        XCTAssert(result)
    }
    
    func testMoreThanLimitFiles() {
        let rotator = try! RotatorConfiguration(maxSize: 50.kiloBytes, maxAge: 0, maxFiles: 4)
        
        let result = rotator.belowMaxNumberOfFiles(6)
        
        XCTAssertFalse(result)
    }
    
    func testRotatorRaisesException() {
        XCTAssertThrowsError(try RotatorConfiguration(maxSize: 0, maxAge: 7.0.daysToSeconds, maxFiles: 11))
    }
    
    func testWithMockFiles() {
        
        let files: [MockedFileManager.MockFile] = [
            .init(path: "This/is/a/path/Logs/log.logs", bytes: 40.kiloBytes),
            .init(path: "This/is/a/path/Logs/log.logs.1", bytes: 30.kiloBytes),
            .init(path: "This/is/a/path/Logs/log.logs.2", bytes: 60.kiloBytes),
            .init(path: "This/is/a/path/Logs/log.logs.3", bytes: 10.kiloBytes)
        ]
        let mockManager = MockedFileManager(files: .init(files))
        
        let rotatorConfiguration = try! RotatorConfiguration(maxSize: 80.kiloBytes, maxAge: 7.0.daysToSeconds, maxFiles: 9)
        
        let result = rotatorConfiguration.check("This/is/a/path/Logs/log.logs", "log", pendingData: Data(count: 200), using: mockManager)
        
        XCTAssert(result)
    }

    static var allTests = [
        ("testSizeLimitNotSet", testSizeLimitNotSet),
        ("testEmptyPath", testEmptyPath),
        ("testBelowMaxSize", testBelowMaxSize),
        ("testOverMaxSize", testOverMaxSize),
        ("testOlderCreationDate", testOlderCreationDate),
        ("testNewerCreationDate", testNewerCreationDate),
        ("testMaxAgeNotSet", testMaxAgeNotSet),
        ("testRotatorRaisesException", testRotatorRaisesException),
        ("testMoreThanLimitFiles", testMoreThanLimitFiles),
        ("testWithMockFiles", testWithMockFiles)
    ]
}
// swiftlint:enable force_try
