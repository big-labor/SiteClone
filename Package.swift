// swift-tools-version:5.5
import PackageDescription

let package = Package(
    name: "SiteClone",
    platforms: [
        .macOS(.v12)
    ],
    products: [
        .executable(
            name: "Run",
            targets: ["Run"]
        ),
        .library(name: "SiteClone", targets: ["SiteClone"])
    ],
    dependencies: [
      .package(url: "https://github.com/scinfu/SwiftSoup.git", from: "1.7.4"),
      .package(url: "https://github.com/JohnSundell/Files", from: "4.0.0"),
        .package(url: "https://github.com/vapor/vapor.git", from: "4.0.0"),
    ],
    targets: [
        .executableTarget(
            name: "Run",
            dependencies: ["SiteClone"]
        ),
        .target(
          name: "SiteClone",
          dependencies: ["SwiftSoup", "Files", .product(name: "Vapor", package: "vapor")],
          swiftSettings: [
            .unsafeFlags(["-parse-as-library"])
          ]
        ),
        .testTarget(
            name: "SiteCloneTests",
            dependencies: [
              "SiteClone"
            ]
        ),
    ]
)
