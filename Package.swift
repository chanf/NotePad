// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "MacNotepadApp",
    platforms: [
        .macOS(.v13)
    ],
    products: [
        .executable(
            name: "MacNotepadApp",
            targets: ["MacNotepadApp"]
        )
    ],
    dependencies: [
        // Add any external dependencies here
    ],
    targets: [
        .executableTarget(
            name: "MacNotepadApp",
            dependencies: [],
            path: "MacNotepadApp",
            exclude: [
                "Resources/Info.plist",
                "Resources"
            ],
            sources: [
                "MacNotepadApp.swift",
                "AppDelegate.swift",
                "ContentView.swift",
                "FindReplacePanel.swift",
                "PreferencesPanel.swift",
                "SimpleTest.swift",
                "ViewModels",
                "Models",
                "Components"
            ],
            resources: [
                .process("Resources/Assets.xcassets")
            ]
        ),
        .testTarget(
            name: "MacNotepadAppTests",
            dependencies: ["MacNotepadApp"],
            path: "MacNotepadAppTests"
        )
    ]
)
