//
//  File.swift
//  
//
//  Created by Francesco Bianco on 02/02/2021.
//

import Foundation

/**
 Describes all the information needed to create a LogMessage.
 */
public protocol LogMessage {
    
    var description: String { get }
    
    var callingThread: String { get }
    var processId: Int32 { get }
    var payload: String { get }
    var severity: LogSeverity { get }
    var callingFilePath: String { get }
    var callingFileLine: Int { get }
    var callingStackFrame: String { get }
    var callingThreadID: UInt64 { get }
    var timestamp: Date { get }
    var channel: String { get }
}

/**
 This is the default LogMessage implementation.
 Note: *It automatically gathers the calling thread and process ID.*
 */
public struct LoggedMessage: Codable, LogMessage, Hashable, Equatable {
    
    public var description: String {
        return ""
    }
    
    public var callingThread: String = ProcessIdentification.current.processName
    public var processId: Int32 = ProcessIdentification.current.processID
    public var payload: String
    public var severity: LogSeverity
    public var callingFilePath: String
    public var callingFileLine: Int
    public var callingStackFrame: String
    public var callingThreadID: UInt64
    public var channel: String
    public var timestamp: Date = Date()
    
}

/**
 Helper struct that gathers the current ProcessIdentification and encapsulates the process's name and identifier.
 */
struct ProcessIdentification {
    // this ensures we only look up process info once
    public static let current = ProcessIdentification()
    
    public let processName: String
    public let processID: Int32

    private init() {
        let process = ProcessInfo.processInfo
        processName = process.processName
        processID = process.processIdentifier
    }
}
    

