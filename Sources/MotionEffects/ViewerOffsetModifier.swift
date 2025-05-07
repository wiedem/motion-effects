import SwiftUI
import UIKit

/// A modifier that provides viewer-based offset values from movements of the device.
public struct ViewerOffsetModifier: ViewModifier {
    private let updateHandler: (_ viewerOffset: UIOffset) -> Void

    /// Creates a view modifier providing viewer based offset values from movements of the device.
    ///
    /// The viewer-based offset values have a value range of -1...1, whereby the initial value is (0, 0).
    ///
    /// - Parameter updateHandler: A handler that receives the viewer based offset values from the movement.
    public init(updateHandler: @escaping (UIOffset) -> Void) {
        self.updateHandler = updateHandler
    }

    public func body(content: Content) -> some View {
        ZStack {
            ViewerOffsetObservation(updateHandler: updateHandler)
                .frame(width: 0, height: 0)
                .allowsHitTesting(false)

            content
        }
    }
}

public extension View {
    /// Provides viewer based offset values from movements of the device for the view.
    ///
    /// - Parameter updateHandler: A handler that receives the viewer based offset values from the movement.
    func onViewerOffset(_ updateHandler: @escaping (_ viewerOffset: UIOffset) -> Void) -> some View {
        modifier(
            ViewerOffsetModifier(updateHandler: updateHandler)
        )
    }
}
