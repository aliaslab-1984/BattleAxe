//
//  BattleAxeFileManager.swift
//  
//
//  Created by Francesco Bianco on 15/12/2020.
//

import Foundation

/// Helper class that lets you manage URLs and folders where all the logs will be stored.
final class BAFileManager {
    
    public static let fileExtension: String = ".logs"
    private let folderName: String
    private static let fileManager = FileManager.default
    
    init(folderName: String) { self.folderName = folderName }
    
    /// Shared instance that uses the default SubFolder name.
    static let standard = BAFileManager(folderName: "BattleAxeLogs")
    
    /// Tries to create a subfolder given a path.
    /// - Parameter path: The base path where you want to create a folder.
    /// - Throws: Throws an error if the operation is not allowed.
    /// - Returns: The path created, nil if an error occurred.
    func createLogsFolderIfNeeded(_ path: String) throws -> String? {
        let finalPath = path + "/" + folderName
        var isDir: ObjCBool = false
        if Self.fileManager.fileExists(atPath: finalPath,
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
            try Self.fileManager.createDirectory(atPath: finalPath,
                                            withIntermediateDirectories: false,
                                            attributes: nil)
            return finalPath
        }
    }
    
    /// Utility method.
    /// - Parameter appGroup: a registered app group. If nil, the method will return the default documentDirectory for the app.
    /// - Returns: Returns an optional url. Nil if the url could not be found.
    func baseURLFor(appGroup: String?) -> URL? {
        let url: URL
        if let group = appGroup {
            guard let customURL = Self.fileManager.containerURL(forSecurityApplicationGroupIdentifier: group) else {
                return nil
            }
            url = customURL
        } else {
            guard let customURL = try? Self.fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) else {
                return nil
            }
            url = customURL
        }
        
        return url
    }
    
}
