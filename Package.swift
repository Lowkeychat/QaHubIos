// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "QaHubIosFramework",
    products: [
        .library(
            name: "QaHubIosFramework",
            targets: ["QaHubIosFramework"]),
    ],
    dependencies: [
        .package(url: "https://github.com/Alamofire/Alamofire.git", .upToNextMajor(from: "5.9.1")),
    ],
    targets: [
        .target(
            name: "QaHubIosFramework",
            dependencies: ["Alamofire"]
        ),
        .testTarget(
            name: "QaHubIosFrameworkTests",
            dependencies: ["QaHubIosFramework"]),
    ]
)
