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
    
    static var allTests = [
        ("testExample", testExample)
    ]
    
}
