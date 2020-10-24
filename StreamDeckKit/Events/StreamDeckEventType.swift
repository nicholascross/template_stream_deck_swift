public enum StreamDeckEventType: String, Decodable {
    case keyDown
    case keyUp
    case willAppear
    case willDisappear
    case deviceDidConnect
    case deviceDidDisconnect
    case applicationDidLaunch
    case applicationDidTerminate
    case systemDidWakeUp
    case titleParametersDidChange
    case didReceiveSettings
    case didReceiveGlobalSettings
    case propertyInspectorDidAppear
    case propertyInspectorDidDisappear
    case sendToPlugin
}
