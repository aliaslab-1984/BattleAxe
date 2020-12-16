//
//  File.swift
//  
//
//  Created by Francesco Bianco on 15/12/2020.
//

import XCTest
@testable import BattleAxe

final class RotatorTests: XCTestCase {
    
    func sizeLimitNotSetTest() {
        let pendingData = Data(count: 30.kiloBytes)
        let fileSize = UInt64(780)
        let rotator = RotatatingLogHandler(maxSize: 0, maxAge: 0)
        
        let result = rotator.doesItFits(fileSize, pendingData.count)
        
        XCTAssert(result)
    }
    
    func belowMaxSizeTest() {
        let pendingData = Data(count: 30.kiloBytes)
        let fileSize = UInt64(780)
        let rotator = RotatatingLogHandler(maxSize: 50.kiloBytes, maxAge: 0)
        
        let result = rotator.doesItFits(fileSize, pendingData.count)
        
        XCTAssert(result)
    }
    
    func overMaxSizeTest() {
        let pendingData = Data(count: 70.kiloBytes)
        let fileSize = UInt64(780)
        let rotator = RotatatingLogHandler(maxSize: 50.kiloBytes, maxAge: 0)
        
        let result = rotator.doesItFits(fileSize, pendingData.count)
        
        XCTAssertFalse(result)
    }
    
    func maxAgeNotSetTest() {
        let rotator = RotatatingLogHandler(maxSize: 0, maxAge: 0)
        
        let fakeFileCreationDate = Date().addingTimeInterval(-14.0.daysToSeconds)
        
        let result = rotator.isSmaller(than:fakeFileCreationDate)
        
        XCTAssert(result)
    }
    
    func olderCreationDateTest() {
        let rotator = RotatatingLogHandler(maxSize: 0, maxAge: 7.0.daysToSeconds)
        
        let fakeFileCreationDate = Date().addingTimeInterval(-14.0.daysToSeconds)
        
        let result = rotator.isSmaller(than: fakeFileCreationDate)
        
        XCTAssertFalse(result)
    }
    
    func newerCreationDateTest() {
        let rotator = RotatatingLogHandler(maxSize: 0, maxAge: 7.0.daysToSeconds)
        
        let fakeFileCreationDate = Date().addingTimeInterval(-24.0.minutesToSeconds)
        
        let result = rotator.isSmaller(than:fakeFileCreationDate)
        
        XCTAssert(result)
    }

    static var allTests = [
        ("sizeLimitNotSetTest", sizeLimitNotSetTest),
        ("belowMaxSizeTest", belowMaxSizeTest),
        ("overMaxSizeTest", overMaxSizeTest),
        ("olderCreationDateTest", olderCreationDateTest),
        ("newerCreationDateTest", newerCreationDateTest),
        ("maxAgeNotSetTest", maxAgeNotSetTest)
    ]
}
