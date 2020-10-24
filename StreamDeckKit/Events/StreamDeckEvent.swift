struct StreamDeckEvent<Payload: Decodable>: Decodable {
    let event: StreamDeckEventType
    let action: String?
    let context: String?
    let device: String?
    let payload: Payload?
    let deviceInfo: DeviceInfo?
}

