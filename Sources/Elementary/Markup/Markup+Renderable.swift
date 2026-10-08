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

extension _AttributesModifier {
    @inlinable
    public consuming func _render<Content: MarkupContent, Renderer: _HTMLRendering>(
        _ content: consuming Content,
        into renderer: inout Renderer,
        with context: consuming _RenderingContext
    ) {
        context.prependAttributes(_attributes)
        Content._render(content, into: &renderer, with: context)
    }

    @inlinable
    @_unavailableInEmbedded
    public consuming func _render<Content: MarkupContent, Renderer: _AsyncHTMLRendering>(
        _ content: consuming Content,
        into renderer: inout Renderer,
        with context: consuming _RenderingContext
    ) async throws {
        context.prependAttributes(_attributes)
        try await Content._render(content, into: &renderer, with: context)
    }
}

extension _TaskLocalModifier where WrappedContent: MarkupContent {
    @inlinable
    public consuming func _render<Content: MarkupContent, Renderer: _HTMLRendering>(
        _ content: consuming Content,
        into renderer: inout Renderer,
        with context: consuming _RenderingContext
    ) {
        taskLocal.withValue(value) { [content, context] in
            Content._render(content, into: &renderer, with: context)
        }
    }

    @_unavailableInEmbedded
    @inlinable
    public consuming func _render<Content: MarkupContent, Renderer: _AsyncHTMLRendering>(
        _ content: consuming Content,
        into renderer: inout Renderer,
        with context: consuming _RenderingContext
    ) async throws {
        try await taskLocal.withValue(value) { [content, context] in
            try await Content._render(content, into: &renderer, with: context)
        }
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
