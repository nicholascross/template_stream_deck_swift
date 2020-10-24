import Foundation

struct SetImagePayload: Encodable {
    /*
        base64 encoded image
        "data:image/png;base64,iVBORw0KGgoA..."
        "data:image/jpg;base64,/9j/4AAQSkZJ..."
        "data:image/bmp;base64,/9j/Qk32PAAA..."
        "data:image/svg+xml;charset=utf8,<svg height=\"100\" width=\"100\"><circle cx=\"50\" cy=\"50\" r=\"40\" stroke=\"black\" stroke-width=\"3\" fill=\"red\" /></svg>"
    */
    let image: String
    let target: TargetType
    let state: String
}
