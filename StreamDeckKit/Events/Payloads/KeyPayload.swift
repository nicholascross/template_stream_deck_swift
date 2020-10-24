import Foundation

struct KeyPayload: Decodable {
    let coordinates: Coordinates
    let isInMultiAction: Bool
    let state: Int?
    let userDesiredState: Int?
}
