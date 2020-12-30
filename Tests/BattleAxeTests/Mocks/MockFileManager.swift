//
//  MockFileManager.swift
//  
//
//  Created by Francesco Bianco on 17/12/2020.
//

import Foundation
import BattleAxe

final class MockedFileManager: FileSystemController {
    
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
        case urlNotFound
    }
    
    func removeItem(atPath path: String) throws {
        guard let item = files.first(where: { (file) -> Bool in
            file.path == path
        }) else {
            throw ManagerError.fileNotFound
        }
        
        files.remove(item)
    }
    
    func fileExists(atPath path: String, isDirectory: UnsafeMutablePointer<ObjCBool>?) -> Bool {
        guard let _ = files.first(where: { (file) -> Bool in
            return file.path == path
        }) else {
            return false
        }
        
        //isDirectory = UnsafeMutablePointer(ObjCBool(false))
        return true
    }
    
    var createdDirectory: Bool = false
    
    func createDirectory(atPath path: String,
                         withIntermediateDirectories createIntermediates: Bool,
                         attributes: [FileAttributeKey : Any]?) throws {
        createdDirectory = true
    }
    
    func containerURL(forSecurityApplicationGroupIdentifier groupIdentifier: String) -> URL? {
        let initialPath = extractBasePath()
        return URL(string: initialPath)
    }
    
    func url(for directory: FileManager.SearchPathDirectory, in domain: FileManager.SearchPathDomainMask, appropriateFor url: URL?, create shouldCreate: Bool) throws -> URL {
        let initialPath = extractBasePath()
        guard let url = URL(string: initialPath) else {
            throw ManagerError.urlNotFound
        }
        return url
    }
    
    func attributesOfItem(atPath path: String) throws -> [FileAttributeKey: Any] {
        guard let item = files.first(where: { (file) -> Bool in
            return file.path == path
        }) else {
            throw ManagerError.fileNotFound
        }
        
        var dictionary: [FileAttributeKey: Any] = [:]
        
        dictionary[.creationDate] = Date(timeInterval: -900, since: Date())
        dictionary[.size] = UInt64(item.dataContents?.count ?? 0)
        
        return dictionary
    }
    
    private func extractBasePath() -> String {
        guard let path = files.first?.path else {
            return ""
        }
        
        let components = path.components(separatedBy: "/")
        guard let last = components.last else {
            return ""
        }
        return path.replacingOccurrences(of: last, with: "")
    }
}
