// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "LookinServer",
    platforms: [
        .iOS(.v9),.tvOS(.v9)
    ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "LookinServer",
            targets: ["LookinServer"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "LookinServer",
            dependencies: [.target(name: "LookinServerSwift")],
            path: "Src/Main",
            publicHeadersPath: "",
            cSettings: [
                .headerSearchPath("**"),
                .headerSearchPath("Server"),
                .headerSearchPath("Server/Category"),
                .headerSearchPath("Server/Connection"),
                .headerSearchPath("Server/Connection/RequestHandler"),
                .headerSearchPath("Server/Inspect"),
                .headerSearchPath("Server/Others"),
                .headerSearchPath("Server/Perspective"),
                .headerSearchPath("Shared"),
                .headerSearchPath("Shared/Category"),
                .headerSearchPath("Shared/Message"),
                .headerSearchPath("Shared/Peertalk"),
            ],
            cxxSettings: [
                .define("SHOULD_COMPILE_LOOKIN_SERVER", to: "1", .when(configuration: .debug)),
                .define("SPM_LOOKIN_SERVER_ENABLED", to: "1", .when(configuration: .debug))
            ]
        ),
        .target(
            name: "LookinServerSwift",
            dependencies: [.target(name: "LookinServerBase")],
            path: "Src/Swift",
            cxxSettings: [
                .define("SHOULD_COMPILE_LOOKIN_SERVER", to: "1", .when(configuration: .debug)),
                .define("SPM_LOOKIN_SERVER_ENABLED", to: "1", .when(configuration: .debug))
            ],
            swiftSettings: [
                .define("SHOULD_COMPILE_LOOKIN_SERVER", .when(configuration: .debug)),
                .define("SPM_LOOKIN_SERVER_ENABLED", .when(configuration: .debug))
            ]
        ),
        .target(
            name: "LookinServerBase",
            dependencies: [],
            path: "Src/Base",
            publicHeadersPath: "",
            cxxSettings: [
                .define("SHOULD_COMPILE_LOOKIN_SERVER", to: "1", .when(configuration: .debug))
            ]
        )
    ]
)
