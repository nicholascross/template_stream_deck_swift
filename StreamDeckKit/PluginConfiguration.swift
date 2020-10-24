import Foundation

public struct PluginConfiguration {
    private let arguments: [String: String]
    
    public init() {
        arguments = CommandLine.arguments.suffix(from: 1).keyValuePairs
        logDebug("arguments: \(arguments.debugDescription)")
    }
    
    public var port: String? {
        arguments["-port"]
    }
    
    public var pluginUUID: String? {
        arguments["-pluginUUID"]
    }
    
    public var registerEvent: String? {
        arguments["-registerEvent"]
    }
    
    public var info: [String: Any]? {
        guard let infoRaw = arguments["-info"], let infoData = infoRaw.data(using: .utf8) else { return nil }
        
        return try? JSONSerialization.jsonObject(with: infoData, options: []) as? [String: Any]
    }
    
    public var pluginPath: String? {
        return Bundle.main.executableURL?.deletingLastPathComponent().absoluteString
    }
}

private extension Collection where Element == String {
    var keyValuePairs: [String: String] {
        let keys = enumerated().filter { index, _ in index % 2 == 0 }.map { $1 }
        let values = enumerated().filter { index, _ in index % 2 != 0 }.map { $1 }
        return Dictionary(uniqueKeysWithValues: zip(keys, values))
    }
}
