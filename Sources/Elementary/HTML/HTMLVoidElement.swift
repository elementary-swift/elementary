/// A markup element that does not contain content.
public struct HTMLVoidElement<Tag: HTMLTrait.Unpaired>: _Attributed, HTML {
    /// The type of the markup tag this element represents.
    public typealias Tag = Tag
    public typealias Body = Never

    public var _attributes: _AttributeStorage

    /// Creates a new unpaired markup element.
    @inlinable
    public init() {
        self._attributes = .init()
    }

    /// Creates a new unpaired markup element with the specified attribute.
    @inlinable
    public init(_ attribute: MarkupAttribute<Tag>) {
        self._attributes = .init(attribute)
    }

    /// Creates a new unpaired markup element with the specified attributes.
    @inlinable
    public init(_ attributes: MarkupAttribute<Tag>...) {
        self._attributes = .init(attributes)
    }

    /// Creates a new unpaired markup element with the specified attributes.
    @inlinable
    public init(attributes: [MarkupAttribute<Tag>]) {
        self._attributes = .init(attributes)
    }
}

extension HTMLVoidElement: Sendable {}

extension HTMLVoidElement: _Renderable {
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
