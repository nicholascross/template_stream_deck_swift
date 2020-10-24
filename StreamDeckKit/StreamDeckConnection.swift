import Foundation
import Starscream

public final class StreamDeckConnection {
    private let port: String
    private let pluginUUID: String
    private let info: [String: Any]
    private let registerEvent: String
    private var webSocketClient: WebSocketClient?
    
    public weak var delegate: StreamDeckConnectionDelegate?
    
    public init(configuration: PluginConfiguration) throws {
        logDebug(configuration.port ?? "port unspecified")
        logDebug(configuration.pluginUUID ?? "pluginUUID unspecified")
        logDebug(configuration.info?.debugDescription ?? "info unspecified")
        logDebug(configuration.registerEvent ?? "register event unspecified")

        guard let port = configuration.port,
              let pluginUUID = configuration.pluginUUID,
              let info = configuration.info,
              let registerEvent = configuration.registerEvent else { throw StreamDeckConnectionError.invalidConfiguration }

        self.port = port
        self.pluginUUID = pluginUUID
        self.info = info
        self.registerEvent = registerEvent
    }
    
    public func connect() {
        guard let url = websocketURL else { return }
        let webSocket = WebSocket(request: URLRequest(url: url))
        webSocket.delegate = self
        webSocket.connect()
        webSocketClient = webSocket
    }
    
    public func disconnect() {
        webSocketClient?.disconnect()
    }

    public func setTitle(_ title: String, context: String, target: TargetType, state: Int) {
        guard let data = StreamDeckAction<SetTitlePayload>(
                event: .setTitle,
                context: context,
                payload: .init(title: title, target: target, state: state),
                action: nil
        ).jsonData else { return }
        
        webSocketClient?.write(stringData: data) {}
    }
    
    public func setImage(_ base64Image: String, context: String, target: TargetType, state: String) {
        guard let data = StreamDeckAction<SetImagePayload>(
                event: .setImage,
                context: context,
            payload: .init(image: base64Image, target: target, state: state),
            action: nil
        ).jsonData else { return }
        
        webSocketClient?.write(stringData: data) {}
    }
    
    public func setState(_ state: String, context: String) {
        guard let data = StreamDeckAction<SetStatePayload>(
                event: .setState,
                context: context,
                payload: .init(state: state),
                action: nil
        ).jsonData else { return }
        
        webSocketClient?.write(stringData: data) {}
    }
    
    public func showAlert(context: String) {
        guard let data = StreamDeckAction<[String: String]>(
                event: .showAlert,
                context: context,
                payload: nil,
                action: nil
        ).jsonData else { return }
        
        webSocketClient?.write(stringData: data) {}
    }
    
    public func showOkay(context: String) {
        guard let data = StreamDeckAction<[String: String]>(
                event: .showOk,
                context: context,
                payload: nil,
                action: nil
        ).jsonData else { return }
        
        webSocketClient?.write(stringData: data) {}
    }
    
    public func switchToProfile(_ profile: String, context: String) {
        guard let data = StreamDeckAction<SwitchToProfilePayload>(
                event: .switchToProfile,
                context: context,
                payload: .init(profile: profile),
                action: nil
        ).jsonData else { return }
        
        webSocketClient?.write(stringData: data) {}
    }
    
    public func sendToPropertyInspector<Payload: Encodable>(_ payload: Payload, action: String, context: String) {
        guard let data = StreamDeckAction<Payload>(
                event: .sendToPropertyInspector,
                context: context,
                payload: payload,
                action: action
        ).jsonData else { return }
        
        webSocketClient?.write(stringData: data) {}
    }

    public func setSettings<Payload: Encodable>(_ payload: Payload, context: String) {
        guard let data = StreamDeckAction<Payload>(
                event: .setSettings,
                context: context,
                payload: payload,
                action: nil
        ).jsonData else { return }
        
        webSocketClient?.write(stringData: data) {}
    }
    
    public func getSettings(context: String) {
        guard let data = StreamDeckAction<[String: String]>(
                event: .getSettings,
                context: context,
                payload: nil,
                action: nil
        ).jsonData else { return }
        
        webSocketClient?.write(stringData: data) {}
    }
    
    public func setGlobalSettings<Payload: Encodable>(_ payload: Payload, context: String) {
        guard let data = StreamDeckAction<Payload>(
                event: .setGlobalSettings,
                context: context,
                payload: payload,
                action: nil
        ).jsonData else { return }
        
        webSocketClient?.write(stringData: data) {}
    }
    
    public func getGlobalSettings(context: String) {
        guard let data = StreamDeckAction<[String: String]>(
                event: .getGlobalSettings,
                context: context,
                payload: nil,
                action: nil
        ).jsonData else { return }
        
        webSocketClient?.write(stringData: data) {}
    }

    public func openURL(_ url: URL, context: String) {
        struct URLPayload: Encodable { let url: String }
        
        guard let data = StreamDeckAction<URLPayload>(
                event: .openUrl,
                context: context,
                payload: URLPayload(url: url.absoluteString),
                action: nil
        ).jsonData else { return }
        
        webSocketClient?.write(stringData: data) {}
    }
    
    public func logMessage(_ message: String, context: String) {
        struct MessagePayload: Encodable { let message: String }
        
        guard let data = StreamDeckAction<MessagePayload>(
                event: .logMessage,
                context: context,
                payload: MessagePayload(message: message),
                action: nil
        ).jsonData else { return }
        
        webSocketClient?.write(stringData: data) {}
    }
    
    private var websocketURL: URL? {
        return URL(string:"ws://127.0.0.1:\(port)")
    }
}

public enum StreamDeckConnectionError: Error {
    case invalidConfiguration
}

extension StreamDeckConnection: WebSocketDelegate {
    public func didReceive(event: WebSocketEvent, client: WebSocket) {
        switch event {
        case .connected(let connectionInfo):
            logDebug("websocket connected: \(connectionInfo)")

            if let data = RegisterAction(event: registerEvent, uuid: pluginUUID).jsonData {
                webSocketClient?.write(data: data)
            }
            
        case .cancelled:
            logDebug("websocket cancelled")
            
        case .disconnected:
            logDebug("websocket disconnected")

        case .reconnectSuggested(let flag):
            logDebug("websocket reconnect suggested \(flag)")
            
        case .viabilityChanged(let flag):
            logDebug("websocket viability changed \(flag)")
            
        case .error(let error):
            logError("websocket error: \(error.debugDescription)")

        case .ping(let data):
            logDebug("websocket ping: \(String(data: data ?? Data(), encoding: .utf8) ?? "")")

        case .pong(let data):
            logDebug("websocket pong: \(String(data:data ?? Data(), encoding: .utf8) ?? "")")

        case .binary(let data):
            logDebug("websocket data: \(String(data:data, encoding: .utf8) ?? "")")

        case .text(let text):
            logDebug("websocket text: \(text)")
            guard let data = text.data(using: .utf8) else { return }
            handleEvent(data: data)
            
        }
    }
    
    func handleEvent(data: Data) {
        guard let eventType = eventType(data: data) else { return }

        switch eventType {
        case .applicationDidLaunch:
            guard let event: StreamDeckEvent<ApplicationPayload> = decodeEvent(data: data),
                    let application = event.payload?.application else {
                logError("Unable to decode event \(String(data: data, encoding: .utf8) ?? "")")
                return
            }
            
            delegate?.didLaunchApplication(application)

        case .applicationDidTerminate:
            guard let event: StreamDeckEvent<ApplicationPayload> = decodeEvent(data: data),
                  let application = event.payload?.application else {
                logError("Unable to decode event \(String(data: data, encoding: .utf8) ?? "")")
                return
            }

            delegate?.didTerminateApplication(application)

        case .deviceDidConnect:
            guard let event: StreamDeckEvent<UndefinedPayload> = decodeEvent(data: data),
                  let device = event.device,
                  let deviceInfo = event.deviceInfo else {
                logError("Unable to decode event \(String(data: data, encoding: .utf8) ?? "")")
                return
            }

            delegate?.didConnectDevice(device, info: deviceInfo)

        case .deviceDidDisconnect:
            guard let event: StreamDeckEvent<UndefinedPayload> = decodeEvent(data: data),
                  let device = event.device,
                  let deviceInfo = event.deviceInfo else {
                logError("Unable to decode event \(String(data: data, encoding: .utf8) ?? "")")
                return
            }

            delegate?.didDisconnectDevice(device, info: deviceInfo)

        case .didReceiveGlobalSettings:
            let settings = extractSettings(data: data)
            delegate?.didReceiveGlobalSettings(settings)

        case .didReceiveSettings:
            guard let event: StreamDeckEvent<UndefinedPayload> = decodeEvent(data: data),
                  let action = event.action,
                  let context = event.context,
                  let device = event.device else {
                logError("Unable to decode event \(String(data: data, encoding: .utf8) ?? "")")
                return
            }

            let settings = extractSettings(data: data)

            delegate?.didReceiveSettings(settings, action: action, context: context, device: device)

        case .keyDown:
            guard let event: StreamDeckEvent<KeyPayload> = decodeEvent(data: data),
                  let action = event.action,
                  let context = event.context,
                  let device = event.device,
                  let payload = event.payload else {
                logError("Unable to decode event \(String(data: data, encoding: .utf8) ?? "")")
                return
            }

            delegate?.keyDown(
                    (payload.coordinates.row, payload.coordinates.column),
                    isInMultiAction: payload.isInMultiAction,
                    action: action,
                    context: context,
                    device: device
            )

        case .keyUp:
            guard let event: StreamDeckEvent<KeyPayload> = decodeEvent(data: data),
                  let action = event.action,
                  let context = event.context,
                  let device = event.device,
                  let payload = event.payload else {
                logError("Unable to decode event \(String(data: data, encoding: .utf8) ?? "")")
                return
            }

            delegate?.keyUp(
                    (payload.coordinates.row, payload.coordinates.column),
                    isInMultiAction: payload.isInMultiAction,
                    action: action,
                    context: context,
                    device: device
            )

        case .propertyInspectorDidAppear:
            guard let event: StreamDeckEvent<UndefinedPayload> = decodeEvent(data: data),
                  let action = event.action,
                  let context = event.context,
                  let device = event.device else {
                logError("Unable to decode event \(String(data: data, encoding: .utf8) ?? "")")
                return
            }

            delegate?.propertyInspectorDidAppear(action: action, context: context, device: device)

        case .propertyInspectorDidDisappear:
            guard let event: StreamDeckEvent<UndefinedPayload> = decodeEvent(data: data),
                  let action = event.action,
                  let context = event.context,
                  let device = event.device else {
                logError("Unable to decode event \(String(data: data, encoding: .utf8) ?? "")")
                return
            }

            delegate?.propertyInspectorDidDisappear(action: action, context: context, device: device)

        case .systemDidWakeUp:
            delegate?.didWakeUp()

        case .titleParametersDidChange:
            guard let event: StreamDeckEvent<TitleDidChangePayload> = decodeEvent(data: data),
                  let action = event.action,
                  let context = event.context,
                  let device = event.device,
                  let payload = event.payload else {
                logError("Unable to decode event \(String(data: data, encoding: .utf8) ?? "")")
                return
            }
            
            let settings = extractSettings(data: data)

            delegate?.didChangeButtonTitle(
                    payload,
                    coordinates: (payload.coordinates.row, payload.coordinates.column),
                    state: payload.state,
                    settings: settings,
                    action: action,
                    context: context,
                    device: device
            )

        case .willAppear:
            guard let event: StreamDeckEvent<StandardPayload> = decodeEvent(data: data),
                  let action = event.action,
                  let context = event.context,
                  let device = event.device,
                  let payload = event.payload else {
                logError("Unable to decode event \(String(data: data, encoding: .utf8) ?? "")")
                return
            }
            
            let settings = extractSettings(data: data)

            delegate?.willAppear(
                    (payload.coordinates.row, payload.coordinates.column),
                    isInMultiAction: payload.isInMultiAction,
                    settings: settings,
                    action: action,
                    context: context,
                    device: device
            )

        case .willDisappear:
            guard let event: StreamDeckEvent<StandardPayload> = decodeEvent(data: data),
                  let action = event.action,
                  let context = event.context,
                  let device = event.device,
                  let payload = event.payload else {
                logError("Unable to decode event \(String(data: data, encoding: .utf8) ?? "")")
                return
            }
            
            let settings = extractSettings(data: data)

            delegate?.willDisappear(
                    (payload.coordinates.row, payload.coordinates.column),
                    isInMultiAction: payload.isInMultiAction,
                    settings: settings,
                    action: action,
                    context: context,
                    device: device
            )

        case .sendToPlugin:
            guard let event: StreamDeckEvent<UndefinedPayload> = decodeEvent(data: data),
                  let action = event.action,
                  let context = event.context else {
                logError("Unable to decode event \(String(data: data, encoding: .utf8) ?? "")")
                return
            }
            
            let payload = extractPayload(data: data)

            delegate?.receivedPayloadFromPropertyInspector(payload, action: action, context: context)

        }
    }
    
    private func eventType(data: Data) -> StreamDeckEventType? {
        struct Event: Decodable {
            let event: StreamDeckEventType
        }
        
        return try? JSONDecoder().decode(Event.self, from: data).event
    }
    
    private func decodeEvent<Payload>(data: Data) -> StreamDeckEvent<Payload>? {
        return try? JSONDecoder().decode(StreamDeckEvent<Payload>.self, from: data)
    }
    
    private func extractPayload(data: Data) -> [String: Any] {
        guard let response = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
              let payload = response["payload"] as? [String: Any] else { return [:] }
        return payload
    }
    
    private func extractSettings(data: Data) -> [String: Any] {
        guard let settings = extractPayload(data: data)["settings"] as? [String: Any] else { return [:] }
        return settings
    }
}
