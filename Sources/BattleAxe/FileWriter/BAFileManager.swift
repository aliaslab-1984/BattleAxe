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
    
    enum RotationError: Error {
        case unableToParseURL
    }
    
    /// Utility method that helps you to rotate the current log file into another.
    /// Specifically it moves the current logs file into another file, and emptys the current log file.
    /// - Parameter filename: The current log file name that needs to be rotated. (without file extension.)
    /// - PArameter currentPath: The current path where the file is located (could include the file name or not.).
    /// - Returns: The path where the old logs have been saved.
    func rotateLogsFile(_ currentPath: String,
                        filename: String) -> Result<String, RotationError> {
        guard let url = URL(string: currentPath) else {
            return .failure(.unableToParseURL)
        }
        
        let currentDirectory: String
        let oldFilePath: String
        let oldFileContents: Data?
        if url.isFileURL {
            // The url is pointing to the current file
            currentDirectory = currentPath.replacingOccurrences(of: filename + Self.fileExtension, with: "")
            oldFileContents = Self.fileManager.contents(atPath: currentPath)
            oldFilePath = currentPath
        } else {
            currentDirectory = currentPath
            oldFilePath = currentPath + "/" + filename + Self.fileExtension
            oldFileContents = Self.fileManager.contents(atPath: oldFilePath)
        }
        // Creates a new file with a unique name, we create the name using an hash of the current file.
        let newFilename: String
        if let contents = oldFileContents {
            if #available(iOS 13.0, *) {
                newFilename = SHA256.hash(data: contents).hexString
            } else {
                var hasher = Hasher()
                hasher.combine(contents)
                let finalValue = hasher.finalize()
                newFilename = "\(finalValue)"
            }
            
        } else {
            // For some reason the old file is empty.. Strange
            newFilename = "oldLogs"
        }
        let newPath = currentDirectory + newFilename + Self.fileExtension
        
        //If a file already exists at path, this method overwrites the contents of that
        //file if the current process has the appropriate privileges to do so.
        Self.fileManager.createFile(atPath: newPath, contents: oldFileContents, attributes: nil)
        Self.fileManager.createFile(atPath: oldFilePath, contents: nil, attributes: nil)
        return .success(newPath)
    }
    
}

#if canImport(CryptoKit)
import CryptoKit

@available(iOS 13.0, *)
extension Digest {
    var bytes: [UInt8] { Array(makeIterator()) }
    var data: Data { Data(bytes) }

    var hexString: String {
        bytes.map { String(format: "%02X", $0) }.joined()
    }
}

#endif
