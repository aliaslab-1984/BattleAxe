//
//  ExtensionsTest.swift
//  
//
//  Created by Francesco Bianco on 17/12/2020.
//

import XCTest
@testable import BattleAxe

final class ExtensionsTest: XCTestCase {
    
    func testIntExtensions() {
        XCTAssert(1.kiloBytes == 1024)
        XCTAssert(1.megaBytes == 1024 * 1024)
        XCTAssert(1.gigaBytes == 1024 * 1024 * 1024)
    }
    
    func testUIntExtensions() {
        XCTAssert(UInt(1).kiloBytes == UInt(1024))
        XCTAssert(UInt(1).megaBytes == UInt(1024 * 1024))
        XCTAssert(UInt(1).gigaBytes == UInt(1024 * 1024 * 1024))
        
        XCTAssert(UInt(68.megaBytes).toHumanReadableBytes == "68MB")
        XCTAssert(UInt(68.kiloBytes).toHumanReadableBytes == "68KB")
        XCTAssert(UInt(68.gigaBytes).toHumanReadableBytes == "68GB")
        XCTAssert(UInt(68).toHumanReadableBytes == "68B")
    }
    
    func testDoubleExtensions() {
        XCTAssert(1.0.minutesToSeconds == 60.0)
        XCTAssert(1.0.hoursToSeconds == 60.0 * 60.0)
        XCTAssert(1.0.daysToSeconds == 60.0 * 60.0 * 24.0)
        
        XCTAssert(3600.0.secondToMinutes == 60)
        XCTAssert(3600.0.secondsToHours == 1)
    }
    
    func testDateFormatter() {
        
        let currentDate = Date()
        let formatter = LogDateFormatter(dateFormat: "yyyy-MM-dd")
        
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
        
        let expectedFormat = "\(year)-\(stringMonth)-\(stringDay)"
        
        XCTAssert(expectedFormat == formatter.getCurrentDateAsString(date: currentDate))
    }
    
    static var allTests = [
        ("testIntExtensions", testIntExtensions),
        ("testUIntExtensions", testUIntExtensions),
        ("testDoubleExtensions", testDoubleExtensions),
        ("testDateFormatter", testDateFormatter)
    ]
    
}

