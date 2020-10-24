enum StreamDeckActionType: String, Encodable {
    case setTitle
    case setImage
    case showAlert
    case showOk
    case getSettings
    case setSettings
    case getGlobalSettings
    case setGlobalSettings
    case setState
    case switchToProfile
    case sendToPropertyInspector
    case openUrl
    case logMessage
}
