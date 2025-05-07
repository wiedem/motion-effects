// swift-tools-version:6.0
import PackageDescription

let package = Package(
    name: "MotionEffects",
    platforms: [
        .iOS(.v15),
    ],
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
                .process("Resources/PrivacyInfo.xcprivacy"),
            ],
            swiftSettings: [
                .swiftLanguageMode(.v6),
                .enableUpcomingFeature("ExistentialAny"),
            ]
        ),
    ]
)
