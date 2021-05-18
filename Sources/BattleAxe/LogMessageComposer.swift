//
//  File.swift
//  
//
//  Created by Francesco Bianco on 14/05/21.
//

import Foundation

/// Helper struct that handles the creation of a printable message, given the message and the needed ingredients.
struct LogMessageFormatter {
    
    /// Given a log message creates a correclty formatted string following the ingredients provided.
    /// - Parameters:
    ///   - message: The message that needs to be formatted.
    ///   - ingredients: The ingredients that need to be added to the formatted message.
    ///   - dateFormatter: The dateformetter style.
    /// - Returns: the formatted string.
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
