//
//  File.swift
//  
//
//  Created by Francesco Bianco on 14/12/2020.
//

import Foundation

struct LoggerConfiguration {
    
    enum LogIngredients: CaseIterable {
        case functionName
        case lineNumber
        case filename
    }
    
    var ingredients: Set<LogIngredients>
    
    static let standard: LoggerConfiguration = .init(ingredients: .init(LogIngredients.allCases))
    static let minimal: LoggerConfiguration = .init(ingredients: .init(arrayLiteral: .functionName))
}
