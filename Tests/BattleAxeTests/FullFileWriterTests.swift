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
        
        let fileWriter = StandardLogFileWriter(filename: "myFile", fileManager: mockManager)
        
        fileWriter.write("Hello")
        
        XCTAssert(true)
    }
    
    static var allTests = [
        ("testExample", testExample)
    ]
    
}
