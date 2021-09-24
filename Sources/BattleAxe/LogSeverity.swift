import Foundation

public enum LogSeverity: Int, Comparable, CaseIterable, Codable {
    
    case verbose = 10
    case debugOnly = 15
    case debug = 20
    case info = 30
    case warning = 40
    case error = 50
    
    public static func < (lhs: LogSeverity, rhs: LogSeverity) -> Bool {
        return lhs.rawValue < rhs.rawValue
    }
}

extension LogSeverity {
    
    /// Returns the corresponding emoji for the LogSeverity.
    public var emoji: String {
        switch self {
        case .info:
            return "ℹ️"
        case .debugOnly:
            return "🐞"
        case .debug:
            return "🔨"
        case .error:
            return "💥"
        case .verbose:
            return "📗"
        case .warning:
            return "⚠️"
        }
    }
}

extension LogSeverity: CustomStringConvertible {
    /** Returns a human-readable textual representation of the receiver. */
    public var description: String {
        switch self {
        case .verbose:
            return "Verbose"
        case .debugOnly:
            return "DebugOnly"
        case .debug:
            return "Debug"
        case .info:
            return "Info"
        case .warning:
            return "Warning"
        case .error:
            return "Error"
        }
    }
    
    /// A pretty printed composition of the emoji and the description for the severity.
    public var prettyDescription: String {
        return emoji + " " + description
    }
}

import os.log

@available (iOS 10.0, *)
internal extension LogSeverity {
    
    var OSLogLevel: OSLogType {
        switch self {
        case .debug, .debugOnly:
            return .debug
        case .error:
            return .error
        case .warning:
            return .fault
        case .info:
            return .info
        case .verbose:
            return .default
        }
    }
    
}
