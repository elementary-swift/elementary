#if !hasFeature(Embedded)
public extension HTMLModifier {
    @inlinable
    consuming func _render<WrappedContent: MarkupContent, Renderer: _HTMLRendering>(
        _ content: consuming WrappedContent,
        into renderer: inout Renderer,
        with context: consuming _RenderingContext
    ) where WrappedContent.Tag == InputTag {
        Body._render(body(content: .init(content)), into: &renderer, with: context)
    }

    @inlinable
    @_unavailableInEmbedded
    consuming func _render<WrappedContent: MarkupContent, Renderer: _AsyncHTMLRendering>(
        _ content: consuming WrappedContent,
        into renderer: inout Renderer,
        with context: consuming _RenderingContext
    ) async throws where WrappedContent.Tag == InputTag {
        try await Body._render(body(content: .init(content)), into: &renderer, with: context)
    }
}

extension _AppliedHTMLModifier {
    @inlinable
    public consuming func _render<Content: MarkupContent, Renderer: _HTMLRendering>(
        _ content: consuming Content,
        into renderer: inout Renderer,
        with context: consuming _RenderingContext
    ) where Content.Tag == InputTag {
        modifier._render(_HTMLModifierContent<Never>(erasing: content), into: &renderer, with: context)
    }

    @inlinable
    @_unavailableInEmbedded
    public consuming func _render<Content: MarkupContent, Renderer: _AsyncHTMLRendering>(
        _ content: consuming Content,
        into renderer: inout Renderer,
        with context: consuming _RenderingContext
    ) async throws where Content.Tag == InputTag {
        try await modifier._render(_HTMLModifierContent<Never>(erasing: content), into: &renderer, with: context)
    }
}

extension _HTMLModifierContent: _Renderable {
    @inlinable
    public static func _render<Renderer: _HTMLRendering>(
        _ html: consuming Self,
        into renderer: inout Renderer,
        with context: consuming _RenderingContext
    ) {
        _renderContent(html.content, into: &renderer, with: context)
    }

    @inlinable
    @_unavailableInEmbedded
    public static func _render<Renderer: _AsyncHTMLRendering>(
        _ html: consuming Self,
        into renderer: inout Renderer,
        with context: consuming _RenderingContext
    ) async throws {
        try await _renderContent(html.content, into: &renderer, with: context)
    }

    @usableFromInline
    static func _renderContent<Content: _Renderable, Renderer: _HTMLRendering>(
        _ content: consuming Content,
        into renderer: inout Renderer,
        with context: consuming _RenderingContext
    ) {
        Content._render(content, into: &renderer, with: context)
    }

    @usableFromInline
    @_unavailableInEmbedded
    static func _renderContent<Content: _Renderable, Renderer: _AsyncHTMLRendering>(
        _ content: consuming Content,
        into renderer: inout Renderer,
        with context: consuming _RenderingContext
    ) async throws {
        try await Content._render(content, into: &renderer, with: context)
    }
}
#endif
