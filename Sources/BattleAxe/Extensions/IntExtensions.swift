//
//  File.swift
//  
//
//  Created by Francesco Bianco on 15/12/2020.
//

import Foundation

extension Int {

    var gigaBytes: Int {
        return Int(UInt(self).gigaBytes)
    }
    
    var megaBytes: Int {
        return Int(UInt(self).megaBytes)
    }
    
    var kiloBytes: Int {
        return Int(UInt(self).kiloBytes)
    }
    
}

extension UInt {
    
    static let oneGigabyte: UInt = oneMegabyte * 1024 // bytes
    static let oneMegabyte: UInt = oneKilobyte * 1024 // bytes
    static let oneKilobyte: UInt = 1024 // bytes
    
    var toHumanReadableBytes: String {
        
        switch self {
        case 0..<Self.oneKilobyte:
            return String(format: "%dB", self as CVarArg)
        case Self.oneKilobyte..<Self.oneMegabyte:
            return String(format: "%dKB", self/Self.oneKilobyte as CVarArg)
        case Self.oneMegabyte..<Self.oneGigabyte:
            return String(format: "%dMB", self/Self.oneMegabyte as CVarArg)
        default:
            return String(format: "%dGB", self/Self.oneGigabyte as CVarArg)
        }
    }
    
    var gigaBytes: UInt {
        return self * Self.oneGigabyte
    }
    
    var megaBytes: UInt {
        return self * Self.oneMegabyte
    }
    
    var kiloBytes: UInt {
        return self * Self.oneKilobyte
    }
    
}

extension Double {
    
    /// Returns the corresponding hour in seconds
    var hoursToSeconds: Double {
        return self * 60.0.minutesToSeconds
    }
    
    /// Returns the corresponding minutes in seconds
    var minutesToSeconds: Double {
        return self * Double(60)
    }
    
    /// Returns the corresponding Days in seconds
    var daysToSeconds: Double {
        return self * 24.0.hoursToSeconds
    }
    
    var secondToMinutes: Double {
        return self / Double(60)
    }
    
    var secondsToHours: Double {
        return self.secondToMinutes / 60
    }
}
