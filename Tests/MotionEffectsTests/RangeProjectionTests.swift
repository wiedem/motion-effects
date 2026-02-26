@testable import MotionEffects
import CoreGraphics
import Testing

struct RangeProjectionTests {
    @Test(arguments: [
        (offset: -1.0, range: -20.0...20.0, expected: -20.0),
        (offset: 0.0, range: -20.0...20.0, expected: 0.0),
        (offset: 1.0, range: -20.0...20.0, expected: 20.0),
        (offset: -1.0, range: 10.0...50.0, expected: 10.0),
        (offset: 0.0, range: 10.0...50.0, expected: 30.0),
        (offset: 1.0, range: 10.0...50.0, expected: 50.0),
    ])
    func projectViewerOffset(
        offset: CGFloat,
        range: ClosedRange<CGFloat>,
        expected: CGFloat
    ) {
        #expect(range.projectViewerOffset(offset) == expected)
    }

    @Test(arguments: [
        (value: 0.0, source: 0.0...10.0, target: 0.0...100.0, expected: 0.0),
        (value: 5.0, source: 0.0...10.0, target: 0.0...100.0, expected: 50.0),
        (value: 10.0, source: 0.0...10.0, target: 0.0...100.0, expected: 100.0),
    ])
    func project(
        value: CGFloat,
        source: ClosedRange<CGFloat>,
        target: ClosedRange<CGFloat>,
        expected: CGFloat
    ) {
        #expect(target.project(value, from: source) == expected)
    }
}
