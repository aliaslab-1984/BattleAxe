//
//  MockFileManager.swift
//  
//
//  Created by Francesco Bianco on 17/12/2020.
//

import Foundation
import BattleAxe

final class MockedFileManager: BAFileManaged {
    
    struct MockFile: Hashable {
        var path: String
        var contents: String?
        
        var dataContents: Data? {
            if let contenut = contents {
                return contenut.data(using: .utf8)
            } else {
                return nil
            }
        }
        
        init(path: String,
             bytes: Int) {
            self.path = path
            self.contents = String(data: Data(count: bytes), encoding: .utf8)
        }
        
        init(path: String,
             contents: String?) {
            self.path = path
            self.contents = contents
        }
    }
    
    var files: Set<MockFile> = .init()
    
    init(files: Set<MockFile>) {
        self.files = files
    }
    
    func contents(atPath path: String) -> Data? {
        if let file = files.first(where: { (loopedFile) -> Bool in
            loopedFile.path == path
        }) {
            return file.dataContents
        } else {
            return nil
        }
    }
    
    @discardableResult
    func createFile(atPath path: String,
                    contents data: Data?,
                    attributes attr: [FileAttributeKey : Any]?) -> Bool {
        
        if let file = files.first(where: { (loopedFile) -> Bool in
            loopedFile.path == path
        }) {
            if let conte = data {
                let newFile = MockFile(path: path,
                                       contents: String(data: conte, encoding: .utf8))
                files.remove(file)
                files.insert(newFile)
            } else {
                let newFile = MockFile(path: path, contents: nil)
                files.remove(file)
                files.insert(newFile)
            }
        } else {
            if let conte = data {
                let newFile = MockFile(path: path, contents: String(data: conte, encoding: .utf8))
                files.insert(newFile)
            } else {
                let newFile = MockFile(path: path, contents: nil)
                files.insert(newFile)
            }
        }
        
        return true
    }
    
    func contentsOfDirectory(atPath path: String) throws -> [String] {
        return files.compactMap { (file) -> String? in
            guard let name = file.path.components(separatedBy: "/").last else {
                return ""
            }
            return name
        }
    }
    
    enum ManagerError: Error {
        case fileNotFound
    }
    
    func removeItem(atPath path: String) throws {
        guard let item = files.first(where: { (file) -> Bool in
            file.path == path
        }) else {
            throw ManagerError.fileNotFound
        }
        
        files.remove(item)
    }
}
