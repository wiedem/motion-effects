# MotionEffects

**MotionEffects** is an open source package that makes motion effect functions available for SwiftUI views on iOS.

## Getting Started

Please note that only iOS platforms with version 13 or higher are currently supported.

To use the `MotionEffects` library in a SwiftPM project, add the following line to the dependencies in your `Package.swift` file:

```swift
.package(url: "https://github.com/wiedem/motion-effects", .upToNextMajor(from: "1.0.0")),
```

Include `"MotionEffects"` as a dependency for your executable target:

```swift
dependencies: [
    .product(name: "MotionEffects", package: "motion-effects"),
]
```

## Usage

Start by adding `import MotionEffects` to your source code.

### Set View Offset based on Viewer Offset

To change the offset of a view based on the offset of the viewer, use the `motionOffset` method:

```swift
import MotionEffects
import SwiftUI

struct DemoView: View {
    var body: some View {
        Color.orange
            .frame(width: 100, height: 100)
            .motionOffset(
                horizontal: -30...30,
                vertical: -30...30
            )
    }
}
```

The viewer-based offsets from the unit space -1...1 are projected into the specified horizontal and vertical offset ranges.

### Custom Effects based on the Viewer Offset

To use a custom effect based on the viewer offset, use the `onViewerOffset` method, which provides the necessary values via a closure:

```swift
import MotionEffects
import SwiftUI

struct DemoView: View {
    @State private var shadowOffset = CGPoint(x: 5, y: 5)

    var body: some View {
        Color.orange
            .frame(width: 100, height: 100)
            .shadow(color: .black.opacity(0.6), radius: 5, x: shadowOffset.x, y: shadowOffset.y)
            .onViewerOffset { viewerOffset in
                // Note that the viewer offset has a unit value range of -1...1
                // Use a transformation of the values depending on the requirements of your use case
                shadowOffset = CGPoint(
                    x: 5 + viewerOffset.horizontal * 3,
                    y: 5 + viewerOffset.vertical * 3
                )
            }
    }
}
```
