// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "QaHubIos",
    platforms: [
           .iOS(.v16)
       ],
    products: [
        .library(
            name: "QaHubIos",
            targets: ["QaHubIos"]),
    ],
    dependencies: [
        .package(url: "https://github.com/Alamofire/Alamofire.git", .upToNextMajor(from: "5.9.1")),
    ],
    targets: [
        .target(
            name: "QaHubIos",
            dependencies: ["Alamofire"]
        ),
        .testTarget(
            name: "QaHubIosTests",
            dependencies: ["QaHubIos"]),
    ]
)
