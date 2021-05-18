//
//  File.swift
//  
//
//  Created by Francesco Bianco on 14/12/2020.
//

import Foundation

/// Defines what pieces are going to be printed/shared by each LogProvider.
public struct LoggerConfiguration: Equatable {
    
    /// Represents each component that is going to be printed/shared by a LogProvider.
    enum LogIngredient: Int, CaseIterable, Equatable, Comparable {
        
        static func < (lhs: LoggerConfiguration.LogIngredient, rhs: LoggerConfiguration.LogIngredient) -> Bool {
            return lhs.rawValue < rhs.rawValue
        }
        
        case channel = 0
        case severity = 1
        case date = 2
        case functionName = 3
        case lineNumber = 4
        case fileName = 5
        case payload = 6
    }
    
    var ingredients: Set<LogIngredient>
    
    /// The standard configuration: it inclues all the available ingredients. The logs will include the
    /// filename, the function's name and the line number.
    public static let standard: LoggerConfiguration = .init(ingredients: .init(LogIngredient.allCases))
    /// A smaller log information: it includes only the function name in the log output.
    public static let minimal: LoggerConfiguration = .init(ingredients: .init(arrayLiteral: .channel, .functionName, .payload))
    /// An even smaller log information: it doesn't includes any information about the file or the function's name.
    public static let naive: LoggerConfiguration = .init(ingredients: .init(arrayLiteral: .channel, .severity, .payload))
}
