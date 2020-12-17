import Foundation

public protocol FileWriter {
    
    var rotationConfiguration: RotatorConfiguration { get }
    func write(_ message: String)
}
