//
//  BattleAxeFileManager.swift
//  
//
//  Created by Francesco Bianco on 15/12/2020.
//

import Foundation

final class BattleAxeFileManager {
    
    private static let folderName: String = "BattleAxeLogs"
    private static let fileManager = FileManager.default
    
    /// Tries to create a subfolder given a path.
    /// - Parameter path: The base path where you want to create a folder.
    /// - Throws: Throws an error if the operation is not allowed.
    /// - Returns: The path created, nil if an error occurred.
    static func createLogsFolderIfNeeded(_ path: String) throws -> String? {
        let finalPath = path + "/" + Self.folderName
        vafr isDir: ObjCBool = false
        if fileManager.fileExists(atPath: finalPath,
                                  isDirectory: &isDir) {
            if isDir.boolValue {
            // file exists and is a directory
                return finalPath
            } else {
            // file exists and is not a directory
                return nil
            }
        } else {
            // file or directory does not exist
            try fileManager.createDirectory(atPath: finalPath,
                                            withIntermediateDirectories: false,
                                            attributes: nil)
            return finalPath
        }
    }
    
}
