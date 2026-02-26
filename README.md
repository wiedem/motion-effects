# MotionEffects

[![Swift 6.0](https://img.shields.io/badge/Swift-6.0-orange.svg)](https://swift.org)
[![iOS 15+](https://img.shields.io/badge/iOS-15%2B-blue.svg)](https://developer.apple.com/ios/)
[![Swift Package Manager](https://img.shields.io/badge/SPM-compatible-brightgreen.svg)](https://swift.org/package-manager/)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE.txt)

A lightweight Swift package that brings motion-based parallax effects to SwiftUI views on iOS. It uses the device gyroscope to offset views based on the viewer's perspective, creating subtle depth and movement effects.

<p align="center">
  <img src="https://raw.githubusercontent.com/wiedem/motion-effects/assets/demo.gif" alt="MotionEffects Demo" width="280">
</p>

## Requirements

- iOS 15+
- Swift 6.0+
- Xcode 16+

## Installation

Add the package dependency to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/wiedem/motion-effects", .upToNextMajor(from: "2.0.0")),
]
```

Then add `"MotionEffects"` to your target's dependencies:

```swift
.target(
    name: "YourTarget",
    dependencies: [
        .product(name: "MotionEffects", package: "motion-effects"),
    ]
)
```

## Usage

```swift
import MotionEffects
```

### Motion Offset

Use `.motionOffset(horizontal:vertical:)` to offset a view based on device movement. The viewer offset values from the unit space `-1...1` are projected into the specified ranges.

```swift
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

### Custom Effects

Use `.onViewerOffset()` to receive raw viewer offset values and apply custom transformations:

```swift
struct DemoView: View {
    @State private var shadowOffset = CGPoint(x: 5, y: 5)

    var body: some View {
        Color.orange
            .frame(width: 100, height: 100)
            .shadow(color: .black.opacity(0.6), radius: 5, x: shadowOffset.x, y: shadowOffset.y)
            .onViewerOffset { viewerOffset in
                // Viewer offset values are in the range -1...1
                shadowOffset = CGPoint(
                    x: 5 + viewerOffset.horizontal * 3,
                    y: 5 + viewerOffset.vertical * 3
                )
            }
    }
}
```

## Accessibility

MotionEffects automatically respects the system **Reduce Motion** setting. When enabled, motion effects are disabled and views return to their default position.

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE.txt) file for details.
