//
//  File.swift
//  
//
//  Created by Francesco Bianco on 29/12/2020.
//

import Foundation

// - MARK: BAFileSeeker
public protocol BAFileSeeker {
    
    func write(_ data: Data)
    func close()
    func readAll() -> Data?
    func open(at path: String)
}
