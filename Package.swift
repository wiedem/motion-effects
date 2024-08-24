// swift-tools-version: 5.10
import PackageDescription

let package = Package(
    name: "MotionEffects",
    platforms: [.iOS(.v13)],
    products: [
        .library(
            name: "MotionEffects",
            targets: ["MotionEffects"]
        ),
    ],
    targets: [
        .target(
            name: "MotionEffects",
            path: "Sources",
            resources: [
                .process("Resources"),
            ]
        ),
    ]
)
