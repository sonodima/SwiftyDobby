import CDobby

public struct Symbol: Hashable, Sendable {
  public let image: String?
  public let name: String

  public init(name: String, image: String? = nil) {
    self.image = image
    self.name = name
  }

  public func resolve() -> UnsafeMutableRawPointer? {
    name.withCString { namePtr in
      if let image {
        return image.withCString { imagePtr in
          DobbySymbolResolver(imagePtr, namePtr)
        }
      }
      return DobbySymbolResolver(nil, namePtr)
    }
  }
}

// MARK: - ExpressibleByStringLiteral

extension Symbol: ExpressibleByStringLiteral {
  public init(stringLiteral value: StringLiteralType) { self.init(name: value) }
}

// MARK: - CustomStringConvertible

extension Symbol: CustomStringConvertible {
  public var description: String {
    if let image { return "\(image):\(name)" }
    return name
  }
}
