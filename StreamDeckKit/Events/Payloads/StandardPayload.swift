import Foundation

struct StandardPayload: Decodable {
    let coordinates: Coordinates
    let isInMultiAction: Bool
}

