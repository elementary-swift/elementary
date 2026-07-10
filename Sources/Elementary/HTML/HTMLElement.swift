/// An HTML element that can contain content.
public struct HTMLElement<Tag: HTMLTrait.Paired, Content: HTML>: _Attributed, HTML {
    public typealias Body = Never

    public var _attributes: _AttributeStorage

    /// The content of the element.
    public var content: Content

    /// Creates a new HTML element with the specified content.
    @inlinable
    public init(@ContentBuilder content: () -> Content) {
        self._attributes = .init()
        self.content = content()
    }

    /// Creates a new HTML element with the specified attribute and content.
    @inlinable
    public init(_ attribute: MarkupAttribute<Tag>, @ContentBuilder content: () -> Content) {
        self._attributes = .init(attribute)
        self.content = content()
    }

    /// Creates a new HTML element with the specified attributes and content.
    @inlinable
    public init(_ attributes: MarkupAttribute<Tag>..., @ContentBuilder content: () -> Content) {
        self._attributes = .init(attributes)
        self.content = content()
    }

    /// Creates a new HTML element with the specified attributes and content.
    @inlinable
    public init(attributes: [MarkupAttribute<Tag>], @ContentBuilder content: () -> Content) {
        self._attributes = .init(attributes)
        self.content = content()
    }
}

public extension HTMLElement where Content == EmptyContent {
    /// Creates a new empty HTML element.
    @inlinable
    init() {
        self._attributes = .init()
        self.content = EmptyContent()
    }

    /// Creates a new empty HTML element with the specified attribute.
    @inlinable
    init(_ attribute: MarkupAttribute<Tag>) {
        self._attributes = .init(attribute)
        self.content = EmptyContent()
    }

    /// Creates a new empty HTML element with the specified attributes.
    @inlinable
    init(_ attributes: MarkupAttribute<Tag>...) {
        self._attributes = .init(attributes)
        self.content = EmptyContent()
    }

    /// Creates a new empty HTML element with the specified attributes.
    @inlinable
    init(attributes: [MarkupAttribute<Tag>]) {
        self._attributes = .init(attributes)
        self.content = EmptyContent()
    }
}

#if !hasFeature(Embedded)
public extension HTMLElement {
    /// Creates a new HTML element with async content.
    @inlinable
    @_unavailableInEmbedded
    init<AwaitedContent: HTML>(
        _ attributes: MarkupAttribute<Tag>...,
        @ContentBuilder content: @escaping @Sendable () async throws -> AwaitedContent
    )
    where Content == AsyncContent<AwaitedContent> {
        self._attributes = .init(attributes)
        self.content = AsyncContent(content: content)
    }

    /// Creates a new HTML element with async content.
    @inlinable
    @_unavailableInEmbedded
    init<AwaitedContent: HTML>(
        attributes: [MarkupAttribute<Tag>],
        @ContentBuilder content: @escaping @Sendable () async throws -> AwaitedContent
    )
    where Content == AsyncContent<AwaitedContent> {
        self._attributes = .init(attributes)
        self.content = AsyncContent(content: content)
    }
}
#endif

extension HTMLElement: Sendable where Content: Sendable {}

extension HTMLElement {
    @inlinable
    public static func _render<Renderer: _HTMLRendering>(
        _ html: consuming Self,
        into renderer: inout Renderer,
        with context: consuming _RenderingContext
    ) {
        html._attributes.append(context.attributes)

        renderer.appendToken(.startTag(Tag.name, attributes: html._attributes.flattened(), isUnpaired: false, type: Tag.renderingType))
        Content._render(html.content, into: &renderer, with: .emptyContext)
        renderer.appendToken(.endTag(Tag.name, type: Tag.renderingType))
    }

    @inlinable
    @_unavailableInEmbedded
    public static func _render<Renderer: _AsyncHTMLRendering>(
        _ html: consuming Self,
        into renderer: inout Renderer,
        with context: consuming _RenderingContext
    ) async throws {
        html._attributes.append(context.attributes)

        try await renderer.appendToken(
            .startTag(Tag.name, attributes: html._attributes.flattened(), isUnpaired: false, type: Tag.renderingType)
        )
        try await Content._render(html.content, into: &renderer, with: .emptyContext)
        try await renderer.appendToken(.endTag(Tag.name, type: Tag.renderingType))
    }
}

/// A type that represents an HTML comment.
///
/// A comment is rendered as `<!--text-->` and the text will be escaped if necessary.
public struct HTMLComment: HTML {
    public typealias Tag = Never
    public typealias Body = Never

    /// The text of the comment.
    public var text: String

    /// Creates a new HTML comment with the specified text.
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
        renderer.appendToken(.comment(html.text))
    }

    @inlinable
    @_unavailableInEmbedded
    public static func _render<Renderer: _AsyncHTMLRendering>(
        _ html: consuming Self,
        into renderer: inout Renderer,
        with context: consuming _RenderingContext
    ) async throws {
        context.assertNoAttributes(self)
        try await renderer.appendToken(.comment(html.text))
    }
}

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

    @inlinable
    public static func _render<Renderer: _HTMLRendering>(
        _ html: consuming Self,
        into renderer: inout Renderer,
        with context: consuming _RenderingContext
    ) {
        context.assertNoAttributes(self)
        renderer.appendToken(.raw(html.text))
    }

    @inlinable
    @_unavailableInEmbedded
    public static func _render<Renderer: _AsyncHTMLRendering>(
        _ html: consuming Self,
        into renderer: inout Renderer,
        with context: consuming _RenderingContext
    ) async throws {
        context.assertNoAttributes(self)
        try await renderer.appendToken(.raw(html.text))
    }
}

extension HTMLComment: Sendable {}
extension HTMLRaw: Sendable {}
