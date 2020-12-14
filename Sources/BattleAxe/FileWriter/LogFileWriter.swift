import Foundation

public final class LogFileWriter: FileWriter {
    
    private var filePath: String
    private var fileHandle: FileHandle?
    private var queue: DispatchQueue
    private static let queueName: String = "LogFileWriter"
    
    public init(filename: String, appGroup: String) {
        let fileManager = FileManager.default
        guard var url = fileManager.containerURL(forSecurityApplicationGroupIdentifier: appGroup) else {
            fatalError("Impossible to set url.")
        }
        
        url.appendPathComponent(filename + ".logs")
        self.filePath = url.path
        self.queue = DispatchQueue(label: Self.queueName)
    }
    
    public init(filePath: String) {
        self.filePath = filePath
        self.queue = DispatchQueue(label: Self.queueName)
    }
    
    public func fileData() -> String {
        guard let data = FileManager.default.contents(atPath: self.filePath), let stringRepresentation = String(data: data, encoding: .utf8) else {
            return ""
        }
        
        return stringRepresentation
    }
    
    deinit {
        fileHandle?.closeFile()
    }
    
    public func write(_ message: String) {
        queue.sync(execute: { [weak self] in
            if let file = self?.getFileHandle() {
                let printed = message + "\n"
                if let data = printed.data(using: String.Encoding.utf8) {
                    file.seekToEndOfFile()
                    file.write(data)
                }
            }
        })
    }
    
    private func getFileHandle() -> FileHandle? {
        if fileHandle == nil {
            let fileManager = FileManager.default
            if !fileManager.fileExists(atPath: filePath) {
                fileManager.createFile(atPath: filePath, contents: nil, attributes: nil)
            }
            
            fileHandle = FileHandle(forWritingAtPath: filePath)
        }
        
        return fileHandle
    }
}
