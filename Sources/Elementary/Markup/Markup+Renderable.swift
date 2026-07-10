#if !hasFeature(Embedded)
public extension MarkupContent {
    @inlinable
    static func _render<Renderer: _HTMLRendering>(
        _ html: consuming Self,
        into renderer: inout Renderer,
        with context: consuming _RenderingContext
    ) {
        Body._render(html.body, into: &renderer, with: context)
    }

    @inlinable
    @_unavailableInEmbedded
    static func _render<Renderer: _AsyncHTMLRendering>(
        _ html: consuming Self,
        into renderer: inout Renderer,
        with context: consuming _RenderingContext
    ) async throws {
        try await Body._render(html.body, into: &renderer, with: context)
    }
}

extension _AttributedContent: _Renderable where Content: _Renderable {
    @inlinable
    public static func _render<Renderer: _HTMLRendering>(
        _ html: consuming Self,
        into renderer: inout Renderer,
        with context: consuming _RenderingContext
    ) {
        context.prependAttributes(html._attributes)
        Content._render(html.content, into: &renderer, with: context)
    }

    @inlinable
    @_unavailableInEmbedded
    public static func _render<Renderer: _AsyncHTMLRendering>(
        _ html: consuming Self,
        into renderer: inout Renderer,
        with context: consuming _RenderingContext
    ) async throws {
        context.prependAttributes(html._attributes)
        try await Content._render(html.content, into: &renderer, with: context)
    }
}

extension _RenderingContext {
    @usableFromInline
    mutating func prependAttributes(_ attributes: consuming _AttributeStorage) {
        attributes.append(self.attributes)
        self.attributes = attributes
    }
}
#endif
