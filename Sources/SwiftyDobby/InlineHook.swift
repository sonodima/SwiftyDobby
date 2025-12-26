import CDobby

public enum InlineHook {
  public struct Handle<Fn> {
    public let address: UnsafeRawPointer
    public let original: Fn

    fileprivate init(address: UnsafeRawPointer, original: Fn) {
      self.address = address
      self.original = original
    }

    public func uninstall() throws(DobbyError) {
      try InlineHook.uninstall(at: address)
    }
  }

  @discardableResult
  public static func install<Fn>(
    at address: UnsafeRawPointer,
    replacingWith replacement: Fn
  ) throws(DobbyError) -> Handle<Fn> {
    let functionPtr = UnsafeMutableRawPointer(mutating: address)
    let fakePtr = unsafeBitCast(replacement, to: UnsafeMutableRawPointer.self)

    var origPtr: UnsafeMutableRawPointer?
    let result = DobbyHook(functionPtr, fakePtr, &origPtr)
    guard result == 0 else { throw DobbyError.hookFailed(code: result) }
    guard let origPtr else { throw DobbyError.missingOriginal }

    return Handle(
      address: address,
      original: unsafeBitCast(origPtr, to: Fn.self)
    )
  }

  @discardableResult
  public static func install<Fn>(
    _ function: Fn,
    replacingWith replacement: Fn
  ) throws(DobbyError) -> Handle<Fn> {
    return try install(
      at: UnsafeRawPointer(
        unsafeBitCast(function, to: UnsafeMutableRawPointer.self)
      ),
      replacingWith: replacement
    )
  }

  @discardableResult
  public static func install<Fn>(
    symbol: Symbol,
    replacingWith replacement: Fn
  ) throws(DobbyError) -> Handle<Fn> {
    guard let address = symbol.resolve() else {
      throw DobbyError.symbolNotFound(symbol)
    }
    return try install(at: address, replacingWith: replacement)
  }

  public static func uninstall(at address: UnsafeRawPointer) throws(DobbyError)
  {
    let funcPtr = UnsafeMutableRawPointer(mutating: address)
    let result = DobbyDestroy(funcPtr)
    guard result == 0 else { throw DobbyError.destroyFailed(code: result) }
  }

  public static func uninstall(symbol: Symbol) throws(DobbyError) {
    guard let address = symbol.resolve() else {
      throw DobbyError.symbolNotFound(symbol)
    }
    try uninstall(at: address)
  }

  public static func uninstall<Fn>(_ function: Fn) throws(DobbyError) {
    try uninstall(
      at: UnsafeRawPointer(
        unsafeBitCast(function, to: UnsafeMutableRawPointer.self)
      )
    )
  }
}
