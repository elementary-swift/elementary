/// An HTML element that can contain content.
public typealias HTMLElement<Tag: HTMLTrait.Paired, Content: HTML> = MarkupElement<Tag, Content>

/// An HTML element that does not contain content.
public struct HTMLVoidElement<Tag: HTMLTagDefinition>: HTML, _Attributed where Tag: HTMLTrait.Unpaired {
    /// The type of the HTML tag this element represents.
    public typealias Tag = Tag
    public typealias Body = Never

    public var _attributes: _AttributeStorage

    /// Creates a new HTML void element.
    @inlinable
    public init() {
        self._attributes = .init()
    }

    /// Creates a new HTML void element with the specified attribute.
    /// - Parameter attribute: The attribute to apply to the element.
    @inlinable
    public init(_ attribute: HTMLAttribute<Tag>) {
        self._attributes = .init(attribute)
    }

    /// Creates a new HTML void element with the specified attributes.
    /// - Parameter attributes: The attributes to apply to the element.
    @inlinable
    public init(_ attributes: HTMLAttribute<Tag>...) {
        self._attributes = .init(attributes)
    }

    /// Creates a new HTML void element with the specified attributes.
    /// - Parameter attributes: The attributes to apply to the element as an array.
    @inlinable
    public init(attributes: [HTMLAttribute<Tag>]) {
        self._attributes = .init(attributes)
    }

    @inlinable
    public static func _render<Renderer: _HTMLRendering>(
        _ html: consuming Self,
        into renderer: inout Renderer,
        with context: consuming _RenderingContext
    ) {
        html._attributes.append(context.attributes)
        renderer.appendToken(.startTag(Tag.name, attributes: html._attributes.flattened(), isUnpaired: true, type: Tag.renderingType))
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
            .startTag(Tag.name, attributes: html._attributes.flattened(), isUnpaired: true, type: Tag.renderingType)
        )
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

extension HTMLVoidElement: Sendable {}
extension HTMLComment: Sendable {}
extension HTMLRaw: Sendable {}
