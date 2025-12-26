import Darwin
import MachO
import SwiftyDobby

// MARK: - Hook by Symbol

typealias PutsFn = @convention(c) (UnsafePointer<CChar>?) -> Int32

nonisolated(unsafe) var putsHandle: InlineHook.Handle<PutsFn>?
let putsHook: PutsFn = { _ in putsHandle!.original("World") }

putsHandle = try! InlineHook.install(symbol: "puts", replacingWith: putsHook)
puts("Hello")
try! putsHandle!.uninstall()
puts("Hello")

// MARK: - Function Hook

typealias SumFn = @convention(c) (Int32, Int32) -> Int32
let sumOrig: SumFn = { a, b in a + b }

nonisolated(unsafe) var sumHandle: InlineHook.Handle<SumFn>?
let sumHook: SumFn = { a, b in sumHandle!.original(a, b) + 1 }

sumHandle = try! InlineHook.install(sumOrig, replacingWith: sumHook)
print("2 + 2 + 1 = \(sumOrig(2, 2))")
try! sumHandle!.uninstall()
print("2 + 2 = \(sumOrig(2, 2))")

// MARK: - Other Image

typealias DyldImageCountFn = @convention(c) () -> UInt32

let dyldImageCountHook: DyldImageCountFn = { 1 }

let dyldImageCountSymbol = Symbol(name: "_dyld_image_count", image: "dyld")
// Here we don't need to access the original function, so we don't need to save the
// hook handle. We can uninstall it directly using the static function.
try! InlineHook.install(
  symbol: dyldImageCountSymbol,
  replacingWith: dyldImageCountHook
)
print("loaded images: \(_dyld_image_count())")
try! InlineHook.uninstall(symbol: dyldImageCountSymbol)
print("loaded images: \(_dyld_image_count())")

// MARK: - Other Image, Alt

// Here we could have done it this way too, assuming that _dyld_image_count was
// available at compile time:
// Here we don't need to access the original function, so we don't need to save the
// hook handle. We can uninstall it directly using the static function.
try! InlineHook.install(_dyld_image_count, replacingWith: dyldImageCountHook)
print("loaded images alt: \(_dyld_image_count())")
try! InlineHook.uninstall(symbol: dyldImageCountSymbol)
print("loaded images alt: \(_dyld_image_count())")
