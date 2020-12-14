//
//  File.swift
//  
//
//  Created by Francesco Bianco on 14/12/2020.
//

import Foundation

public struct LoggerConfiguration: Equatable {
    
    enum LogIngredient: CaseIterable, Equatable {
        case functionName
        case lineNumber
        case fileName
    }
    
    var ingredients: Set<LogIngredient>
    
    /// The standard configuration: it inclues all the available ingredients. The logs will include the
    /// filename, the function's name and the line number.
    public static let standard: LoggerConfiguration = .init(ingredients: .init(LogIngredient.allCases))
    /// A smaller log information: it includes only the function name in the log output.
    public static let minimal: LoggerConfiguration = .init(ingredients: .init(arrayLiteral: .functionName))
    /// An even smaller log information: it doesn't includes any information about the file or the function's name.
    public static let onlyMessage: LoggerConfiguration = .init(ingredients: .init())
}
