import Foundation
import StreamDeckKit
import CoreLocation
import SwiftUI

public final class Plugin: StreamDeckConnectionDelegate {
    private let connection: StreamDeckConnection
    private let primaryAction: PrimaryAction
    
    init(connection: StreamDeckConnection) {
        self.connection = connection
        self.primaryAction = PrimaryAction(connection: connection)
    }

    public func didReceiveSettings(_ settings: [String : Any], action: String, context: String, device: String) {
        switch ActionType(rawValue: action) {
        case .primary:
            primaryAction.didReceiveSettings(settings, action: action, context: context, device: device)
        default:
            break
        }
    }
    
    public func keyDown(_ coordinates: (row: Int, column: Int), isInMultiAction: Bool, action: String, context: String, device: String) {
        switch ActionType(rawValue: action) {
        case .primary:
            primaryAction.keyDown(coordinates, isInMultiAction: isInMultiAction, action: action, context: context, device: device)
        default:
            break
        }
    }
    
    public func keyUp(_ coordinates: (row: Int, column: Int), isInMultiAction: Bool, action: String, context: String, device: String) {
        switch ActionType(rawValue: action) {
        case .primary:
            primaryAction.keyUp(coordinates, isInMultiAction: isInMultiAction, action: action, context: context, device: device)
        default:
            break
        }
    }
    
    public func propertyInspectorDidAppear(action: String, context: String, device: String) {
        switch ActionType(rawValue: action) {
        case .primary:
            primaryAction.propertyInspectorDidAppear(action: action, context: context, device: device)
        default:
            break
        }
    }
    
    public func propertyInspectorDidDisappear(action: String, context: String, device: String) {
        switch ActionType(rawValue: action) {
        case .primary:
            primaryAction.propertyInspectorDidDisappear(action: action, context: context, device: device)
        default:
            break
        }
    }
    
    public func willAppear(_ coordinates: (row: Int, column: Int), isInMultiAction: Bool, settings: [String : Any], action: String, context: String, device: String) {
        switch ActionType(rawValue: action) {
        case .primary:
            primaryAction.willAppear(coordinates, isInMultiAction: isInMultiAction, settings: settings, action: action, context: context, device: device)
        default:
            break
        }
    }
    
    public func willDisappear(_ coordinates: (row: Int, column: Int), isInMultiAction: Bool, settings: [String : Any], action: String, context: String, device: String) {
        switch ActionType(rawValue: action) {
        case .primary:
            primaryAction.willDisappear(coordinates, isInMultiAction: isInMultiAction, settings: settings, action: action, context: context, device: device)
        default:
            break
        }
    }
    
    public func receivedPayloadFromPropertyInspector(_ payload: [String : Any], action: String, context: String) {
        switch ActionType(rawValue: action) {
        case .primary:
            primaryAction.receivedPayloadFromPropertyInspector(payload, action: action, context: context)
        default:
            break
        }
    }
    
    public func didChangeButtonTitle(_ title: ButtonTitle, coordinates: (Int, Int), state: Int, settings: [String : Any], action: String, context: String, device: String) {
        switch ActionType(rawValue: action) {
        case .primary:
            primaryAction.didChangeButtonTitle(title, coordinates: coordinates, state: state, settings: settings, action: action, context: context, device: device)
        default:
            break
        }
    }
    
    public func didLaunchApplication(_ application: String) {
        
    }
    
    public func didTerminateApplication(_ application: String) {
        
    }
    
    public func didConnectDevice(_: String, info: DeviceInfo) {
        
    }
    
    public func didDisconnectDevice(_: String, info: DeviceInfo) {
        
    }
    
    public func didReceiveGlobalSettings(_ settings: [String : Any]) {

    }
    
    public func didWakeUp() {
        
    }
}

private enum ActionType: String, Decodable {
    case primary = "<PLUGIN_BUNDLE_IDENTIFIER>.action"
}
