import Foundation

public protocol StreamDeckConnectionDelegate: AnyObject {
    func didLaunchApplication(_ application: String)
    func didTerminateApplication(_ application: String)
    func didConnectDevice(_: String, info: DeviceInfo)
    func didDisconnectDevice(_: String, info: DeviceInfo)
    func didReceiveSettings(_: [String: Any], action: String, context: String, device: String)
    func didReceiveGlobalSettings(_: [String: Any])
    func keyDown(_: (row: Int, column: Int), isInMultiAction: Bool, action: String, context: String, device: String)
    func keyUp(_: (row: Int, column: Int), isInMultiAction: Bool, action: String, context: String, device: String)
    func didWakeUp()
    func propertyInspectorDidAppear(action: String, context: String, device: String)
    func propertyInspectorDidDisappear(action: String, context: String, device: String)
    func willAppear(_: (row: Int, column: Int), isInMultiAction: Bool, settings: [String: Any], action: String, context: String, device: String)
    func willDisappear(_: (row: Int, column: Int), isInMultiAction: Bool, settings: [String: Any], action: String, context: String, device: String)
    func receivedPayloadFromPropertyInspector(_: [String: Any], action: String, context: String)
    func didChangeButtonTitle(_: ButtonTitle, coordinates: (Int, Int), state: Int, settings: [String: Any], action: String, context: String, device: String)
}
