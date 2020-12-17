//
//  RotatorTests.swift
//  
//
//  Created by Francesco Bianco on 17/12/2020.
//

import XCTest
@testable import BattleAxe

final class RotatorTests: XCTestCase {
    
    func testRotateFileAreTooMuch() {
        let basePath = "This/is/a/Path/Logs"
        let initialFiles = [MockedFileManager.MockFile(path: basePath + "/ciao.logs", contents: "Ciao ciao, siamo dei logs!"),
            MockedFileManager.MockFile(path: basePath + "/ciao.logs.1", contents: "Ciao ciao, siamo dei logs anche noi!"),
            MockedFileManager.MockFile(path: basePath + "/ciao.logs.2", contents: "Ciao ciao, siamo dei logs anche voi!"),
            MockedFileManager.MockFile(path: basePath + "/ciao.logs.3", contents: "Ciao ciao, siamo dei logs anche nosotros!")]
        let mockManager = MockedFileManager(files: .init( initialFiles))
        
        let myManager = BAFileManager(folderName: "Logs", fileManager: mockManager)
        let result = myManager.rotateLogsFile(basePath,
                                 filename: "ciao",
                                 rotationConfiguration: try! .init(maxSize: 0, maxAge: 0, maxFiles: 2))
        
        switch result {
        case .success:
            let newValues = mockManager.files.shuffled()
            XCTAssert(initialFiles != newValues)
        default:
            XCTFail()
        }
        
    }
    
    func testRotateFileIsTooHeavy() {
        let basePath = "This/is/a/Path/Logs"
        let initialFiles = [MockedFileManager.MockFile(path: basePath + "/ciao.logs", bytes: 10.megaBytes),
                            MockedFileManager.MockFile(path: basePath + "/ciao.logs.1", bytes: 5.megaBytes)
        ]
        let mockManager = MockedFileManager(files: .init( initialFiles))
        let configuration = try! RotatorConfiguration(maxSize: 1.kiloBytes, maxAge: 0, maxFiles: 2)
        
        XCTAssertFalse(configuration.doesItFits(UInt64(initialFiles.first!.dataContents!.count), 1.kiloBytes))
        
        let myManager = BAFileManager(folderName: "Logs", fileManager: mockManager)
        let result = myManager.rotateLogsFile(basePath,
                                              filename: "ciao",
                                              rotationConfiguration: configuration)
        switch result {
        case .success:
            XCTAssert(initialFiles.count < mockManager.files.count)
        default:
            XCTFail()
        }
    }
    
    func testRotateFileIsTooOld() {
        let basePath = "This/is/a/Path/Logs"
        let initialFiles = [MockedFileManager.MockFile(path: basePath + "/ciao.logs", bytes: 1.megaBytes),
                            MockedFileManager.MockFile(path: basePath + "/ciao.logs.1", bytes: 1.megaBytes)
        ]
        let mockManager = MockedFileManager(files: .init( initialFiles))
        let configuration = try! RotatorConfiguration(maxSize: 0, maxAge: 1.0.hoursToSeconds, maxFiles: 2)
        
        XCTAssert(configuration.isOlder(than: Date().addingTimeInterval(0.5.hoursToSeconds)))
        
        let myManager = BAFileManager(folderName: "Logs", fileManager: mockManager)
        let result = myManager.rotateLogsFile(basePath,
                                              filename: "ciao",
                                              rotationConfiguration: configuration)
        switch result {
        case .success:
            XCTAssert(initialFiles.count < mockManager.files.count)
        default:
            XCTFail()
        }
    }
    
    static var allTests = [
        ("testRotateFileAreTooMuch", testRotateFileAreTooMuch),
        ("testRotateFileIsTooHeavy", testRotateFileIsTooHeavy),
        ("testRotateFileIsTooOld", testRotateFileIsTooOld)
    ]
}
