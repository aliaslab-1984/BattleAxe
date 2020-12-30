//
//  StandardLogFileWriter.swift
//
//
//  Created by Francesco Bianco on 15/12/2020.
//

import Foundation

public final class StandardLogFileWriter: BaseFileWriter {
    
    public override func write(_ message: String) {
        queue.sync(execute: { [weak self] in
            
            guard let strongSelf = self else {
                return
            }
            
            // We need to check if the rotator's check passes before writing.
            let check = rotationConfiguration.check(strongSelf.filePath,
                                                    strongSelf.filename,
                                                    pendingData: message.data(using: .utf8) ?? Data())
            guard check else {
                _ = manager.rotateLogsFile(strongSelf.filePath,
                                           filename: strongSelf.filename,
                                           rotationConfiguration: rotationConfiguration)
                // We close and make the file handle reference nil, so the getFileHandle() mehod returns a
                // brand new file.
                fileSeeker.close()
                
                self?.writeAndCR(message)
                return
            }
            
            self?.writeAndCR(message)
        })
    }
    
    private func writeAndCR(_ message: String) {
        let printed = message + "\n"
        printed.appendTo(file: fileSeeker)
    }
    
}
