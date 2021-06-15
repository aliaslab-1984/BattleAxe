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
            
            let prefix = ingredient.prefixDecoration
            let postfix = ingredient.postfixDecoration
            
            switch ingredient {
            case .channel:
                finalMessage.append("\(prefix)\(message.channel)\(postfix)")
            case .severity:
                finalMessage.append("\(prefix)\(message.severity.prettyDescription)\(postfix)")
            case .date:
                finalMessage.append("\(prefix)\(dateFormatter.getCurrentDateAsString())\(postfix)")
            case .fileName:
                finalMessage.append("\(prefix)\(message.callingFilePath)\(postfix)")
            case .lineNumber:
                finalMessage.append("\(prefix)\(message.callingFileLine)\(postfix)")
            case .functionName:
                finalMessage.append("\(prefix)\(message.callingStackFrame)\(postfix)")
            case .payload:
                finalMessage.append("\(prefix)\(message.payload)\(postfix)")
            }
        }
        
        return finalMessage
    }
}

extension LoggerConfiguration.LogIngredient {
    
    var prefixDecoration: String {
        
        switch self {
        case .channel: return "{"
        case .severity: return "["
        case .date: return "⏱ "
        case .fileName: return "📂 "
        case .lineNumber: return "("
        case .functionName: return "🤖 "
        case .payload: return " 🔈💬"
        }
    }
    
    var postfixDecoration: String {
        
        switch self {
        case .channel: return "} "
        case .severity: return "] "
        case .date: return " "
        case .fileName: return ":"
        case .lineNumber: return ") "
        case .functionName: return ""
        case .payload: return ""
        }
    }
}
