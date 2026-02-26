public import SwiftUI

/// A modifier that offsets a view based on the viewer offset caused by a movement of the device.
public struct MotionOffsetModifier: ViewModifier {
    @Environment(\.accessibilityReduceMotion) private var accessibilityReduceMotion
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
            .modifier(OnChangeModifier(value: accessibilityReduceMotion) { reduceMotion in
                if reduceMotion {
                    viewerBasedOffset = .zero
                }
            })
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

extension ClosedRange where Bound == CGFloat {
    func project(
        _ value: CGFloat,
        from sourceRange: ClosedRange<CGFloat>
    ) -> CGFloat {
        lowerBound + (upperBound - lowerBound) * (value - sourceRange.lowerBound) / (sourceRange.upperBound - sourceRange.lowerBound)
    }

    func projectViewerOffset(_ offset: CGFloat) -> CGFloat {
        project(offset, from: -1...1)
    }
}

#Preview {
    ZStack {
        Rectangle()
            .strokeBorder(Color.primary, lineWidth: 1)
            .frame(width: 190, height: 140)

        Text("Motion Demo")
            .frame(width: 150, height: 100)
            .background(Color.orange)
            .cornerRadius(5)
            .motionOffset(
                horizontal: -20...20,
                vertical: -20...20
            )
    }
}
