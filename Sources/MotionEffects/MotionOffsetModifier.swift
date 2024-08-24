import SwiftUI

/// A modifier that offsets a view based on the viewer offset caused by a movement of the device.
public struct MotionOffsetModifier: ViewModifier {
    @State private var viewerBasedOffset: CGSize = .zero
    private var horizontalOffsetRange: ClosedRange<CGFloat>?
    private var verticalOffsetRange: ClosedRange<CGFloat>?

    /// Creates a view modifier that offsets a view based on motion values.
    ///
    /// Use offset ranges that are suitable for your application.
    ///
    /// Motion offsets are transformed into the specified ranges.
    /// In the initial state, the movement offset is (0, 0) and is transformed to the center of the specified range.
    ///
    /// For a target offset range of -20...20, the view offset is therefore also (0, 0) in the initial state.
    ///
    /// - Parameters:
    ///   - horizontalOffsetRange: The horizontal offset range by which the view is to be adjusted.
    ///   - verticalOffsetRange: The vertical offset range by which the view is to be adjusted.
    public init(
        horizontal horizontalOffsetRange: ClosedRange<CGFloat>? = nil,
        vertical verticalOffsetRange: ClosedRange<CGFloat>? = nil
    ) {
        self.horizontalOffsetRange = horizontalOffsetRange
        self.verticalOffsetRange = verticalOffsetRange
    }

    public func body(content: Content) -> some View {
        content
            .offset(viewerBasedOffset)
            .onViewerOffset { viewerOffset in
                viewerBasedOffset = .init(
                    width: horizontalOffsetRange?.projectViewerOffset(viewerOffset.horizontal) ?? 0,
                    height: verticalOffsetRange?.projectViewerOffset(viewerOffset.vertical) ?? 0
                )
            }
    }
}

public extension View {
    /// Adds an offset to the view based on the motion of the device.
    ///
    /// - Parameters:
    ///   - horizontalOffsetRange: The horizontal offset range by which the view is to be adjusted.
    ///   - verticalOffsetRange: The vertical offset range by which the view is to be adjusted.
    func motionOffset(
        horizontal horizontalOffsetRange: ClosedRange<CGFloat>? = nil,
        vertical verticalOffsetRange: ClosedRange<CGFloat>? = nil
    ) -> some View {
        modifier(MotionOffsetModifier(
            horizontal: horizontalOffsetRange,
            vertical: verticalOffsetRange
        ))
    }
}

private extension ClosedRange where Bound == CGFloat {
    func project(_ value: CGFloat, from sourceRange: ClosedRange<CGFloat>) -> CGFloat {
        lowerBound + (upperBound - lowerBound) * (value - sourceRange.lowerBound) / (sourceRange.upperBound - sourceRange.lowerBound)
    }

    func projectViewerOffset(_ offset: CGFloat) -> CGFloat {
        project(offset, from: -1...1)
    }
}
