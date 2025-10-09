// swift-tools-version:4.0

import PackageDescription

let package = Package(
  name: "gl-math",
  products: [
    .library(name: "GLMath", targets: ["GLMath"]),
    .executable(name: "swizgen", targets: ["Tools"]),
  ],
  targets: [
    .target(name: "GLMath", dependencies: []),
    .target(name: "Tools", dependencies: []),
    .testTarget(name: "GLMathTests", dependencies: ["GLMath"]),
  ]
)
