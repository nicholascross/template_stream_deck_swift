import Foundation

struct TitleDidChangePayload: Decodable {
    let coordinates: Coordinates
    let state: Int
    let title: String
    let titleParameters: TitleParameters
}

struct TitleParameters: Decodable {
    let fontFamily: String
    let fontSize: Float
    let fontStyle: String
    let fontUnderline: Bool
    let showTitle: Bool
    let titleAlignment: String
    let titleColor: String
}

extension TitleDidChangePayload: ButtonTitle {
    public var fontFamily: String {
        titleParameters.fontFamily
    }
    public var fontSize: Float {
        titleParameters.fontSize
    }
    public var fontStyle: String {
        titleParameters.fontStyle
    }
    public var fontUnderline: Bool {
        titleParameters.fontUnderline
    }
    public var showTitle: Bool {
        titleParameters.showTitle
    }
    public var titleAlignment: String {
        titleParameters.titleAlignment
    }
    public var titleColor: String {
        titleParameters.titleColor
    }
}

public protocol ButtonTitle {
    var title: String { get }
    var fontFamily: String { get }
    var fontSize: Float { get }
    var fontStyle: String { get }
    var fontUnderline: Bool { get }
    var showTitle: Bool { get }
    var titleAlignment: String { get }
    var titleColor: String { get }
}