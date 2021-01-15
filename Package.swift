// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.
import PackageDescription

let packageName = "LookinServer"
let targetName = "LookinServer"

let package = Package(
    name: packageName,
    defaultLocalization: "en",
    platforms: [
        .iOS(.v9),
    ],
    products: [
        // Products define the executables and libraries produced by a package, and make them visible to other packages.
        .library(name: packageName, targets: [targetName]),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: targetName,
            path: "SourceCode",
            // SPM不能使用PCH
            exclude:[
                "LookinShared/Peertalk/prefix.pch",
                "LookinServer/LookinServer_Info.plist",
            ],
            // 源代码和需要复制的资源地址不能重复
            sources: [
                "LookinShared",
                "LookinServer/Category",
                "LookinServer/Connection",
                "LookinServer/Inspect",
                "LookinServer/Others",
                "LookinServer/Perspective",
            ],
            // 复制用户的资源到SPM Bundle中
            // 不需要主动处理Localizable.strings, SPM自己会处理
            resources: [
                .copy("LookinServer/LookinServerImages.bundle"),
            ],
            // 不公开头文件，默认是xxx/include(因为文件不存在默认会有警告)
            publicHeadersPath: "",
            // -I$SRCROOT/SourceCode/**
            // 使用 SPM_RESOURCE_BUNDLE_IDENTIFITER 获取SPM Bundle资源
            cSettings: [
                .headerSearchPath("**"),
                .define("CAN_COMPILE_LOOKIN_SERVER", .when(configuration: .debug)),
                .define("SPM_RESOURCE_BUNDLE_IDENTIFITER", to: "@\"\(packageName)-\(targetName)-resources\""),
            ]),
    ]
)

