//
//  File.swift
//  
//
//  Created by Francesco Bianco on 15/12/2020.
//

import XCTest
@testable import BattleAxe

final class RotatorConfigurationTests: XCTestCase {
    
    func testSizeLimitNotSet() {
        let pendingData = Data(count: 30.kiloBytes)
        let fileSize = UInt64(780)
        let rotator = try! RotatorConfiguration(maxSize: 0, maxAge: 0, maxFiles: 0)
        
        let result = rotator.doesItFits(fileSize, pendingData.count)
        
        XCTAssert(result)
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
        
        let result = rotator.isOlder(than:fakeFileCreationDate)
        
        XCTAssertFalse(result)
    }
    
    func testOlderCreationDate() {
        let rotator = try! RotatorConfiguration(maxSize: 0, maxAge: 7.0.daysToSeconds, maxFiles: 1)
        
        let fakeFileCreationDate = Date().addingTimeInterval(-14.0.daysToSeconds)
        
        let result = rotator.isOlder(than: fakeFileCreationDate)
        
        XCTAssertFalse(result)
    }
    
    func testNewerCreationDate() {
        let rotator = try! RotatorConfiguration(maxSize: 0, maxAge: 7.0.daysToSeconds, maxFiles: 1)
        
        let fakeFileCreationDate = Date().addingTimeInterval(-24.0.minutesToSeconds)
        
        let result = rotator.isOlder(than:fakeFileCreationDate)
        
        XCTAssert(result)
    }
    
    func testRotatorRaisesException() {
        XCTAssertThrowsError(try RotatorConfiguration(maxSize: 0, maxAge: 7.0.daysToSeconds, maxFiles: 11))
    }

    static var allTests = [
        ("testSizeLimitNotSet", testSizeLimitNotSet),
        ("testBelowMaxSize", testBelowMaxSize),
        ("testOverMaxSize", testOverMaxSize),
        ("testOlderCreationDate", testOlderCreationDate),
        ("testNewerCreationDate", testNewerCreationDate),
        ("testMaxAgeNotSet", testMaxAgeNotSet),
        ("testRotatorRaisesException", testRotatorRaisesException)
    ]
}
