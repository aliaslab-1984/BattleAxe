//
//  BriefLogFileWriter.swift
//  
//
//  Created by Francesco Bianco on 15/12/2020.
//

import Foundation

/// FileWriter that stores logs in a more compact format:
/// `message [number of times]\n`
public final class BriefLogFileWriter: BaseFileWriter {
    
    // Specific for this type of FileWriter:
    // It keeps a reference of the last message that has been sent.
    // If the last message is the same as the actual one, it increases the count.
    private var lastMessage: String?
    private var counter: Int = 1

    public override func write(_ message: String) {
        queue.sync(execute: { [weak self] in
            guard let strongSelf = self else {
                return
            }
            
            guard let unMessage = lastMessage else {
                let check = rotationConfiguration.check(filePath,
                                                        filename,
                                                        pendingData: message.data(using: .utf8) ?? Data())
                
                guard check else {
                    _ = manager.rotateLogsFile(filePath,
                                                filename: filename,
                                                rotationConfiguration: rotationConfiguration)
                    // We close and make the file handle reference nil, so the getFileHandle() mehod returns a
                    // brand new file.
                    fileSeeker.close()
                    
                    message.appendTo(file: fileSeeker)
                    strongSelf.lastMessage = message
                    strongSelf.counter = 1
                    return
                }
                message.appendTo(file: fileSeeker)
                strongSelf.lastMessage = message
                strongSelf.counter = 1
                return
            }
            
            if message == unMessage {
                strongSelf.counter += 1
            } else {
                " [\(strongSelf.counter) times]\n".appendTo(file: fileSeeker)
                strongSelf.counter = 1
                strongSelf.lastMessage = message
                message.appendTo(file: fileSeeker)
            }
        })
    }
    
}
