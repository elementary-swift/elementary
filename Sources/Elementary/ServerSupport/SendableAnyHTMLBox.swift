#if !hasFeature(Embedded)
/// A wrapper around an `any HTML` value that can be safely sent once.
///
/// Note: For non-sendable values, this will only allow the value to be taken only once.
/// Sendable values can safely be taken multiple times.

@available(iOS 18, *)
public struct _SendableAnyHTMLBox: Sendable {
    var storage: Storage

    enum Storage {
        case sendable(any HTML & Sendable)
        // NOTE: protocol can be removed when macOS 15 is the minimum
        case sendOnceBox(any SendOnceBoxing<any HTML>)
    }

    public init(_ html: any HTML & Sendable) {
        storage = .sendable(html)
    }

    @available(macOS 15, *)
    public init(_ html: sending any HTML) {
        storage = .sendOnceBox(SendOnceBox(html))
    }

    public consuming func tryTake() -> sending (any HTML)? {
        switch storage {
        case let .sendable(html):
            return html
        case let .sendOnceBox(box):
            return box.tryTake()
        }
    }
}
#endif
