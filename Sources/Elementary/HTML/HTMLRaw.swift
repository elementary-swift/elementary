/// A type that represents custom raw, untyped HTML.
///
/// The text is rendered as-is without any validation or escaping.
public struct HTMLRaw: HTML {
    public typealias Tag = Never
    public typealias Body = Never

    /// The raw HTML text.
    public var text: String

    /// Creates a new raw HTML content with the specified text.
    public init(_ text: String) {
        self.text = text
    }
}

extension HTMLRaw: Sendable {}
