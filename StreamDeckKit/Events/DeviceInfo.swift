import Foundation

public struct DeviceInfo: Decodable {
    let name: String
    let size: Dimensions
    let type: Int
}

public struct Dimensions: Decodable {
    let columns: Int
    let rows: Int
}
