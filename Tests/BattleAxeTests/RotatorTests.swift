//
//  RotatorTests.swift
//  
//
//  Created by Francesco Bianco on 17/12/2020.
//

import XCTest
@testable import BattleAxe

final class RotatorTests: XCTestCase {
    
    func testSomething() {
        let basePath = "ciao/Ciao/cIaO/Logs"
        let mockManager = MockedFileManager(files: .init(arrayLiteral:
                                                            MockedFileManager.MockFile(path: basePath + "/ciao.logs", contents: "Ciao ciao, siamo dei logs!"),
                                                            MockedFileManager.MockFile(path: basePath + "/ciao.logs.1", contents: "Ciao ciao, siamo dei logs anche noi!"),
                                                            MockedFileManager.MockFile(path: basePath + "/ciao.logs.2", contents: "Ciao ciao, siamo dei logs anche voi!")
        ))
        
        let myManager = BAFileManager(folderName: "Logs", fileManager: mockManager)
        let result = myManager.rotateLogsFile(basePath,
                                 filename: "ciao",
                                 rotationConfiguration: try! .init(maxSize: 0, maxAge: 0, maxFiles: 2))
        
        switch result {
        case .success(let value):
            print(value)
        default:
            XCTFail()
        }
        
    }
    
    static var allTests = [
        ("testSomething", testSomething)
    ]
}