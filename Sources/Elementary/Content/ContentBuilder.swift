/// A result builder for building content components.
@resultBuilder public struct ContentBuilder {
    @inlinable
    public static func buildExpression<Content>(_ content: Content) -> Content {
        content
    }

    @inlinable
    public static func buildExpression(_ content: String) -> StringContent {
        StringContent(content)
    }

    @inlinable
    public static func buildBlock() -> EmptyContent {
        EmptyContent()
    }

    @inlinable
    public static func buildBlock<Content>(_ content: Content) -> Content {
        content
    }

    @inlinable
    public static func buildIf<Content>(_ content: Content?) -> Content? {
        content
    }

    @inlinable
    public static func buildEither<TrueContent, FalseContent>(first: TrueContent) -> _ConditionalContent<TrueContent, FalseContent> {
        _ConditionalContent(.trueContent(first))
    }

    @inlinable
    public static func buildEither<TrueContent, FalseContent>(
        second: FalseContent
    ) -> _ConditionalContent<TrueContent, FalseContent> {
        _ConditionalContent(.falseContent(second))
    }

    @inlinable
    public static func buildArray<Element>(_ components: [Element]) -> _ArrayContent<Element> {
        _ArrayContent(components)
    }
}

/// A type that represents empty content.
public struct EmptyContent: Sendable {
    @inlinable
    public init() {}
}

/// A type that represents text content in an HTML document.
///
/// The text will be escaped when rendered.
public struct StringContent: Sendable {
    /// The text content.
    public var text: String

    /// Creates a new text content with the specified text.
    @inlinable
    public init(_ text: String) {
        self.text = text
    }
}

extension _ConditionalContent.Value: Sendable where TrueContent: Sendable, FalseContent: Sendable {}
extension _ConditionalContent: Sendable where _ConditionalContent.Value: Sendable {}

public struct _ConditionalContent<TrueContent, FalseContent> {
    public enum Value {
        case trueContent(TrueContent)
        case falseContent(FalseContent)
    }

    public let value: Value

    @inlinable
    public init(_ value: Value) {
        self.value = value
    }
}

extension _ArrayContent: Sendable where Element: Sendable {}

public struct _ArrayContent<Element> {
    public let value: [Element]

    @inlinable
    public init(_ value: [Element]) {
        self.value = value
    }
}
