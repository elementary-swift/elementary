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

/// Compatibility alias for ``ContentBuilder``.
///
/// Prefer ``ContentBuilder`` for new code. This alias is kept for source compatibility and will eventually be deprecated and removed.
public typealias HTMLBuilder = ContentBuilder

extension Never: MarkupContent {
    public typealias Tag = Never
    public typealias Body = Never
}

extension Never: HTML {}

extension Optional: _Renderable where Wrapped: _Renderable {
    @inlinable
    public static func _render<Renderer: _HTMLRendering>(
        _ html: consuming Self,
        into renderer: inout Renderer,
        with context: consuming _RenderingContext
    ) {
        switch html {
        case .none: return
        case let .some(value): Wrapped._render(value, into: &renderer, with: context)
        }
    }

    @inlinable
    @_unavailableInEmbedded
    public static func _render<Renderer: _AsyncHTMLRendering>(
        _ html: consuming Self,
        into renderer: inout Renderer,
        with context: consuming _RenderingContext
    ) async throws {
        switch html {
        case .none: break
        case let .some(value): try await Wrapped._render(value, into: &renderer, with: context)
        }
    }
}

extension Optional: MarkupContent where Wrapped: MarkupContent {
    public typealias Tag = Wrapped.Tag
    public typealias Body = Never
}

extension Optional: HTML where Wrapped: HTML {}

/// A type that represents empty content.
public struct EmptyContent: _Renderable, MarkupContent, Sendable {
    public typealias Tag = Never
    public typealias Body = Never

    public init() {}

    @inlinable
    public static func _render<Renderer: _HTMLRendering>(
        _ html: consuming Self,
        into renderer: inout Renderer,
        with context: consuming _RenderingContext
    ) {
        context.assertNoAttributes(self)
    }

    @inlinable
    @_unavailableInEmbedded
    public static func _render<Renderer: _AsyncHTMLRendering>(
        _ html: consuming Self,
        into renderer: inout Renderer,
        with context: consuming _RenderingContext
    ) async throws {
        context.assertNoAttributes(self)
    }
}

extension EmptyContent: HTML {}

/// Compatibility alias for ``EmptyContent``.
///
/// Prefer ``EmptyContent`` for new code. This alias is kept for source compatibility and will eventually be deprecated and removed.
public typealias EmptyHTML = EmptyContent

/// A type that represents text content in an HTML document.
///
/// The text will be escaped when rendered.
public struct StringContent: _Renderable, MarkupContent, Sendable {
    public typealias Tag = Never
    public typealias Body = Never

    /// The text content.
    public var text: String

    /// Creates a new text content with the specified text.
    @inlinable
    public init(_ text: String) {
        self.text = text
    }

    @inlinable
    public static func _render<Renderer: _HTMLRendering>(
        _ html: consuming Self,
        into renderer: inout Renderer,
        with context: consuming _RenderingContext
    ) {
        context.assertNoAttributes(self)
        renderer.appendToken(.text(html.text))
    }

    @inlinable
    @_unavailableInEmbedded
    public static func _render<Renderer: _AsyncHTMLRendering>(
        _ html: consuming Self,
        into renderer: inout Renderer,
        with context: consuming _RenderingContext
    ) async throws {
        context.assertNoAttributes(self)
        try await renderer.appendToken(.text(html.text))
    }
}

extension StringContent: HTML {}

/// Compatibility alias for ``StringContent``.
///
/// Prefer ``StringContent`` for new code. This alias is kept for source compatibility and will eventually be deprecated and removed.
public typealias HTMLText = StringContent

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

extension _ConditionalContent: _Renderable where TrueContent: _Renderable, FalseContent: _Renderable {
    @inlinable
    public static func _render<Renderer: _HTMLRendering>(
        _ html: consuming Self,
        into renderer: inout Renderer,
        with context: consuming _RenderingContext
    ) {
        switch html.value {
        case let .trueContent(content): return TrueContent._render(content, into: &renderer, with: context)
        case let .falseContent(content): return FalseContent._render(content, into: &renderer, with: context)
        }
    }

    @inlinable
    @_unavailableInEmbedded
    public static func _render<Renderer: _AsyncHTMLRendering>(
        _ html: consuming Self,
        into renderer: inout Renderer,
        with context: consuming _RenderingContext
    ) async throws {
        switch html.value {
        case let .trueContent(content): try await TrueContent._render(content, into: &renderer, with: context)
        case let .falseContent(content): try await FalseContent._render(content, into: &renderer, with: context)
        }
    }
}

extension _ConditionalContent: MarkupContent where TrueContent: MarkupContent, FalseContent: MarkupContent {
    public typealias Body = Never
}

public extension _ConditionalContent where TrueContent: MarkupContent, FalseContent: MarkupContent, TrueContent.Tag == FalseContent.Tag {
    typealias Tag = TrueContent.Tag
}

extension _ConditionalContent: HTML where TrueContent: HTML, FalseContent: HTML {}

/// Deprecated compatibility alias for ``_ConditionalContent``.
///
/// Prefer ``_ConditionalContent`` for new code. This alias is kept for the upgrade path and will be removed in a future release.
@available(*, deprecated, renamed: "_ConditionalContent")
public typealias _HTMLConditional<TrueContent, FalseContent> = _ConditionalContent<TrueContent, FalseContent>

extension _ArrayContent: Sendable where Element: Sendable {}

public struct _ArrayContent<Element> {
    public let value: [Element]

    @inlinable
    public init(_ value: [Element]) {
        self.value = value
    }
}

extension _ArrayContent: _Renderable where Element: _Renderable {
    @inlinable
    public static func _render<Renderer: _HTMLRendering>(
        _ html: consuming Self,
        into renderer: inout Renderer,
        with context: consuming _RenderingContext
    ) {
        context.assertNoAttributes(self)

        for element in html.value {
            Element._render(element, into: &renderer, with: copy context)
        }
    }

    @inlinable
    @_unavailableInEmbedded
    public static func _render<Renderer: _AsyncHTMLRendering>(
        _ html: consuming Self,
        into renderer: inout Renderer,
        with context: consuming _RenderingContext
    ) async throws {
        context.assertNoAttributes(self)

        for element in html.value {
            try await Element._render(element, into: &renderer, with: copy context)
        }
    }
}

extension _ArrayContent: MarkupContent where Element: MarkupContent {
    public typealias Body = Never
}

extension _ArrayContent: HTML where Element: HTML {}

/// Deprecated compatibility alias for ``_ArrayContent``.
///
/// Prefer ``_ArrayContent`` for new code. This alias is kept for the upgrade path and will be removed in a future release.
@available(*, deprecated, renamed: "_ArrayContent")
public typealias _HTMLArray<Element> = _ArrayContent<Element>
