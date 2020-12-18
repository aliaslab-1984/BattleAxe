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
    private let manager: BAFileManaged
    
    init(folderName: String,
         fileManager: BAFileManaged = FileManager.default) {
        self.folderName = folderName
        self.manager = fileManager
    }
    
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
    /// - Parameter currentPath: The current path where the file is located. Must be the filepath with the filename and extension.
    /// - Returns: The path where the old logs have been saved.
    func rotateLogsFile(_ currentPath: String,
                        filename: String,
                        rotationConfiguration: RotatorConfiguration) -> String {
        
            // The url is pointing to the current file
        let currentDirectory = currentPath.replacingOccurrences(of: filename + Self.fileExtension, with: "")
        
        // Creates a new file with a unique name
        let newFilename = newName(directory: currentDirectory,
                                  filename: filename,
                                  rotationConfiguration: rotationConfiguration)
        let newPath = currentDirectory + newFilename
        return newPath
    }
    
    /// Creates a new file if needed, and rotates the current logs.
    /// - Parameters:
    ///   - directory: The full path where the logs are stored.
    ///   - filename: The filename for the current log file. (without extension)
    ///   - rotationConfiguration: The rotation configuration.
    /// - Returns: returns the filename created.
    private func newName(directory: String,
                         filename: String,
                         rotationConfiguration: RotatorConfiguration) -> String {
        let currentFile = directory + filename + Self.fileExtension
        guard var items = try? manager.contentsOfDirectory(atPath: directory) else {
            return filename + Self.fileExtension
        }
        
        items.removeAll { (item) -> Bool in
            item == filename + Self.fileExtension
        }
        
        items.sort()
        
        let filenames = items.compactMap {
            // We extract the filename from each path.
            return $0.components(separatedBy: "/").last
        }
        
        let availableNumbers = filenames.compactMap { (item) -> Int? in
            let components = item.components(separatedBy: ".")
            if let last = components.last,
               let intRepresentation = Int(last) {
                return intRepresentation
            } else {
                return nil
            }
        }
        
        guard rotationConfiguration.belowMaxNumberOfFiles(filenames.count) else {
            // We reached the file number limit, so we just rotate without creating a new file.
            rotate(items, currentFile, directory)
            return ""
        }
        
        let newFilename: String
        if let last = availableNumbers.last {
            newFilename = filename + Self.fileExtension + "." + "\(last + 1)"
        } else {
            newFilename = filename + Self.fileExtension + ".1"
        }
        
        items.append(newFilename)
        rotate(items, currentFile, directory)
        
        return newFilename
    }
    
    private func rotate(_ storedFilePaths: [String],
                        _ currentFilePath: String,
                        _ currentDirectory: String) {
        
        var reversedPaths = storedFilePaths
        reversedPaths.sort()
        reversedPaths.reverse()
        // I loop over the reversed file paths, and i overwrite the looped item with the next one on the list.
        for (index, item) in reversedPaths.enumerated() {
            let nextIndex = index + 1
            guard nextIndex < reversedPaths.count else {
                break
            }
            let nextItem = reversedPaths[nextIndex]
            
            let oldFileContents = manager.contents(atPath: nextItem)
            
            // I overwrite the current item with the next item in the paths list.
            manager.createFile(atPath: currentDirectory + item, contents: oldFileContents, attributes: nil)
        }
        
        guard let first = storedFilePaths.first else {
            return
        }
        
        let contents =  Self.fileManager.contents(atPath: currentFilePath)
        //If a file already exists at path, this method overwrites the contents of that
        //file if the current process has the appropriate privileges to do so.
        manager.createFile(atPath: currentDirectory + first, contents: contents, attributes: nil)
        manager.createFile(atPath: currentFilePath, contents: nil, attributes: nil)
    }
    
    func deleteAllLogs(filePath: String,
                       filename: String) -> [String] {
        let directory = filePath.replacingOccurrences(of: filename + Self.fileExtension, with: "")
        guard var items = try? manager.contentsOfDirectory(atPath: directory) else {
            return []
        }
        
        var failingItems: [String] = []
        items.forEach { (itemToBeRemoved) in
            let path = directory + itemToBeRemoved
            do {
            try FileManager.default.removeItem(atPath: path)
            } catch _ {
                print("Error")
                failingItems.append(path)
            }
        }
        
        return failingItems
    }
}
