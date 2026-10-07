#if !hasFeature(Embedded)
import Synchronization

@available(iOS 18, macOS 15, *)
final class SendOnceBox<Value>: Sendable, SendOnceBoxing {
    let mutex: Mutex<Value?>

    init(_ value: sending Value) {
        mutex = Mutex(value)
    }

    func tryTake() -> sending Value? {
        mutex.withLock { value -> sending Value? in
            let result = value
            value = nil
            return result
        }
    }
}

// NOTE: this is for macOS runtime availability of SendOnceBox and can be removed when macOS 15 is the minimum
protocol SendOnceBoxing<Value>: AnyObject, Sendable {
    associatedtype Value
    func tryTake() -> sending Value?
}
#endif
