import Foundation

struct SetTitlePayload: Encodable {
    let title: String
    let target: TargetType
    let state: Int
}
