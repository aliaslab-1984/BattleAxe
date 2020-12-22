//
//  File.swift
//  
//
//  Created by Francesco Bianco on 17/12/2020.
//

import Foundation

public protocol BAFileManaged {
    
    func contents(atPath path: String) -> Data?
    @discardableResult
    func createFile(atPath path: String, contents data: Data?, attributes attr: [FileAttributeKey : Any]?) -> Bool
    func contentsOfDirectory(atPath path: String) throws -> [String]
    func removeItem(atPath path: String) throws
}


extension FileManager: BAFileManaged { }
