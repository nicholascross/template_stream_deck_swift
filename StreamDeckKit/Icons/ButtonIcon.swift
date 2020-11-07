import Foundation
import AppKit
import SwiftUI
import CoreGraphics

public protocol ButtonIcon: AnyObject {
    var base64ImageString: String? { get }
}

public extension StreamDeckConnection {
    
    func setButtonIcon(_ icon: ButtonIcon, context: String, target: TargetType = .both, state: Int? = nil) {
        if let image = icon.base64ImageString {
            setImage(image, context: context, target: target, state: state)
        }
    }
    
    func setButtonIcon<IconView: View>(context: String, target: TargetType = .both, state: Int? = nil, @ViewBuilder viewBuilder: @escaping () -> IconView) {
        let button = ViewButtonIcon(content: viewBuilder)
        if let image = button.base64ImageString {
            self.setImage(image, context: context, target: target, state: state)
        }
    }
    
    func setButtonIcon(context: String, target: TargetType = .both, state: Int? = nil, view: NSView) {
        let button = NSViewButtonIcon(view: view)
        if let image = button.base64ImageString {
            self.setImage(image, context: context, target: target, state: state)
        }
    }
    
}


private final class ViewButtonIcon<Content: View>: ButtonIcon {
    private let view: NSView
    
    public init(@ViewBuilder content: @escaping () -> Content) {
        self.view = NSHostingView(rootView: content())
        view.frame = CGRect(x: 0, y: 0, width: 72, height: 72)
    }
    
    public var base64ImageString: String? {
        return image.base64String
    }
    
    private var image: NSImage {
        return view.snapshot
    }
}

private final class NSViewButtonIcon: ButtonIcon {
    private let view: NSView
    
    init(view: NSView) {
        self.view = view
    }
    
    public var base64ImageString: String? {
        return image.base64String
    }
    
    private var image: NSImage {
        return view.snapshot
    }
}
