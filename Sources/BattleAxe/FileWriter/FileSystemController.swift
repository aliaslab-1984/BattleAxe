//
//  File.swift
//  
//
//  Created by Francesco Bianco on 17/12/2020.
//

import Foundation

/// Utility protocol to encapsulate and make testable all the required `FileManager` features.
public protocol FileSystemController {
    
    func contents(atPath path: String) -> Data?
    
    @discardableResult
    func createFile(atPath path: String, contents data: Data?, attributes attr: [FileAttributeKey : Any]?) -> Bool
    
    func contentsOfDirectory(atPath path: String) throws -> [String]
    
    func removeItem(atPath path: String) throws
    
    func fileExists(atPath path: String, isDirectory: UnsafeMutablePointer<ObjCBool>?) -> Bool
    
    func createDirectory(atPath path: String, withIntermediateDirectories createIntermediates: Bool, attributes: [FileAttributeKey : Any]?) throws
    
    func containerURL(forSecurityApplicationGroupIdentifier groupIdentifier: String) -> URL?
    
    func url(for directory: FileManager.SearchPathDirectory, in domain: FileManager.SearchPathDomainMask, appropriateFor url: URL?, create shouldCreate: Bool) throws -> URL
}


extension FileManager: FileSystemController { }
