import Elementary

public struct SVGRoot<Content: SVGContent>: SVGContent, HTML, _Attributed {
    public typealias Tag = SVGTag.svg
    public typealias Body = Never
    public typealias Content = Content

    @usableFromInline
    var element: MarkupElement<SVGTag.svg, Content>

    public var _attributes: _AttributeStorage {
        _read { yield element._attributes }
        _modify { yield &element._attributes }
    }

    @inlinable
    public init(@ContentBuilder content: () -> Content) {
        self.element = MarkupElement(content: content)
    }

    @inlinable
    public init(_ attribute: SVGAttribute<SVGTag.svg>, @ContentBuilder content: () -> Content) {
        self.element = MarkupElement(attribute, content: content)
    }

    @inlinable
    public init(_ attributes: SVGAttribute<SVGTag.svg>..., @ContentBuilder content: () -> Content) {
        self.element = MarkupElement(attributes: attributes, content: content)
    }

    @inlinable
    public init(attributes: [SVGAttribute<SVGTag.svg>], @ContentBuilder content: () -> Content) {
        self.element = MarkupElement(attributes: attributes, content: content)
    }

    @inlinable
    public static func _render<Renderer: _HTMLRendering>(
        _ html: consuming Self,
        into renderer: inout Renderer,
        with context: consuming _RenderingContext
    ) {
        MarkupElement._render(html.element, into: &renderer, with: context)
    }

    @inlinable
    @_unavailableInEmbedded
    public static func _render<Renderer: _AsyncHTMLRendering>(
        _ html: consuming Self,
        into renderer: inout Renderer,
        with context: consuming _RenderingContext
    ) async throws {
        try await MarkupElement._render(html.element, into: &renderer, with: context)
    }
}

public extension SVGRoot where Content == EmptyContent {
    @inlinable
    init() {
        self.element = MarkupElement()
    }

    @inlinable
    init(_ attribute: SVGAttribute<SVGTag.svg>) {
        self.element = MarkupElement(attribute)
    }

    @inlinable
    init(_ attributes: SVGAttribute<SVGTag.svg>...) {
        self.element = MarkupElement(attributes: attributes)
    }

    @inlinable
    init(attributes: [SVGAttribute<SVGTag.svg>]) {
        self.element = MarkupElement(attributes: attributes)
    }
}

extension SVGRoot: Sendable where Content: Sendable {}
