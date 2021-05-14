//
//  File.swift
//  
//
//  Created by Francesco Bianco on 14/05/21.
//

import Foundation

public struct LogMessageComposer {
    
    static func compose(_ message: LogMessage,
                        using ingredients: [LoggerConfiguration.LogIngredient],
                        dateFormatter: DateFormatter) -> String {
        var finalMessage: String = ""
        
        ingredients.forEach { ingredient in
            switch ingredient {
            case .channel:
                finalMessage.append("{\(message.channel)} ")
            case .severity:
                finalMessage.append("[\(message.severity.prettyDescription)] ")
            case .date:
                finalMessage.append("\(dateFormatter.getCurrentDateAsString()) ")
            case .fileName:
                finalMessage.append("\(message.callingFilePath):")
            case .functionName:
                finalMessage.append("\(message.callingStackFrame):")
            case .lineNumber:
                finalMessage.append("(\(message.callingFileLine))")
            case .payload:
                finalMessage.append("\(message.payload)")
            }
        }
        
        return finalMessage
    }
    
}
