import Foundation
import StreamDeckKit

public final class Plugin: StreamDeckConnectionDelegate {
    private let connection: StreamDeckConnection
    
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
    
    public func didReceiveSettings(_: [String : Any], action: String, context: String, device: String) {
        
    }
    
    public func didReceiveGlobalSettings(_: [String : Any]) {
        
    }
    
    public func keyDown(_: (row: Int, column: Int), isInMultiAction: Bool, action: String, context: String, device: String) {
        logDebug("Key down")
        connection.setTitle("Down", context: context, target: .both, state: 0)
    }
    
    public func keyUp(_: (row: Int, column: Int), isInMultiAction: Bool, action: String, context: String, device: String) {
        logDebug("Key up")
        connection.setTitle("Up", context: context, target: .both, state: 0)
    }
    
    public func didWakeUp() {
        
    }
    
    public func propertyInspectorDidAppear(action: String, context: String, device: String) {
        
    }
    
    public func propertyInspectorDidDisappear(action: String, context: String, device: String) {
        
    }
    
    public func willAppear(_: (row: Int, column: Int), isInMultiAction: Bool, settings: [String : Any], action: String, context: String, device: String) {
        
    }
    
    public func willDisappear(_: (row: Int, column: Int), isInMultiAction: Bool, settings: [String : Any], action: String, context: String, device: String) {
        
    }
    
    public func receivedPayloadFromPropertyInspector(_: [String : Any], action: String, context: String) {
        
    }
    
    public func didChangeButtonTitle(_: ButtonTitle, coordinates: (Int, Int), state: Int, settings: [String : Any], action: String, context: String, device: String) {
        
    }

}
