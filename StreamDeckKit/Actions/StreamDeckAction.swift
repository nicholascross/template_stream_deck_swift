import Foundation

public struct StreamDeckAction<Payload: Encodable>: Encodable {
    let event: StreamDeckActionType
    let context: String
    let payload: Payload?
    let action: String?
}

