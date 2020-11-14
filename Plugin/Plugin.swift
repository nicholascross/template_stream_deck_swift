import Foundation
import StreamDeckKit

public final class Plugin: StreamDeckConnectionDelegate {
    private let connection: StreamDeckConnection
    
    private var loadedSettings: [String: Settings] = [:]
    
    init(connection: StreamDeckConnection) {
        self.connection = connection
    }
    
    public func didLaunchApplication(_ application: String) {
        
    }
    
    public func didTerminateApplication(_ application: String) {
        
    }
    
    public func didConnectDevice(_: String, info: DeviceInfo) {
        
    }
    
    public func didDisconnectDevice(_: String, info: DeviceInfo) {
        
    }
    
    public func didReceiveSettings(_ settings: [String : Any], action: String, context: String, device: String) {
        logDebug("didReceiveSettings: \(settings)")
        
        if let settings = try? JSONDecoder().decode(Settings.self, from: JSONSerialization.data(withJSONObject: settings, options: .prettyPrinted)) {
            loadedSettings[context] = settings
            connection.setTitle("\(settings.count)", context: context, target: .both, state: 0)
        }
    }
    
    public func didReceiveGlobalSettings(_ settings: [String : Any]) {
        logDebug("didReceiveGlobalSettings: \(settings)")
    }
    
    public func keyDown(_: (row: Int, column: Int), isInMultiAction: Bool, action: String, context: String, device: String) {
        logDebug("Key down")
        
        let settings = settingsForContext(context)
        updateSettingsForContext(context, count: settings.count + 1)
    }
    
    public func keyUp(_: (row: Int, column: Int), isInMultiAction: Bool, action: String, context: String, device: String) {
        logDebug("Key up")
        connection.setTitle("\(settingsForContext(context).count)", context: context, target: .both, state: 0)
    }
    
    public func didWakeUp() {
        
    }
    
    public func propertyInspectorDidAppear(action: String, context: String, device: String) {
        logDebug("Property inspector did appear")
        
        connection.getSettings(context: context)
    }
    
    public func propertyInspectorDidDisappear(action: String, context: String, device: String) {
        logDebug("Property inspector did disappear")
    }
    
    public func willAppear(_: (row: Int, column: Int), isInMultiAction: Bool, settings: [String : Any], action: String, context: String, device: String) {
        logDebug("will appear: \(action)")
        connection.getSettings(context: context)
    }
    
    public func willDisappear(_: (row: Int, column: Int), isInMultiAction: Bool, settings: [String : Any], action: String, context: String, device: String) {
        logDebug("will disappear: \(action)")
    }
    
    public func receivedPayloadFromPropertyInspector(_ payload: [String : Any], action: String, context: String) {
        logDebug("received payload: \(payload)")
    }
    
    public func didChangeButtonTitle(_: ButtonTitle, coordinates: (Int, Int), state: Int, settings: [String : Any], action: String, context: String, device: String) {
        
    }

    private func settingsForContext(_ context: String) -> Settings {
        return loadedSettings[context] ?? Settings(count: 0)
    }
    
    private func updateSettingsForContext(_ context: String, count: Int) {
        let settings = Settings(count: count)
        loadedSettings[context] = settings
        connection.setSettings(settings, context: context)
    }
}

public struct Settings: Codable {
    var count: Int
}
