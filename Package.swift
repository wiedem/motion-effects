// swift-tools-version: 6.0
import PackageDescription

let commonSwiftSettings: [SwiftSetting] = [
    .enableUpcomingFeature("ExistentialAny"),
    .enableUpcomingFeature("InternalImportsByDefault"),
    .enableUpcomingFeature("StrictConcurrency"),
]

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
            swiftSettings: commonSwiftSettings
        ),
        .testTarget(
            name: "MotionEffectsTests",
            dependencies: ["MotionEffects"],
            swiftSettings: commonSwiftSettings
        ),
    ],
    swiftLanguageModes: [.v6]
)
