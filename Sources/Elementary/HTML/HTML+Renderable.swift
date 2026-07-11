extension HTMLTagDefinition {
    @inlinable
    static var renderingType: _HTMLRenderToken.RenderingType {
        _rendersInline ? .inline : .block
    }
}

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

    #if !hasFeature(Embedded)
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
    #endif
}

extension HTMLVoidElement {
    @inlinable
    public static func _render<Renderer: _HTMLRendering>(
        _ html: consuming Self,
        into renderer: inout Renderer,
        with context: consuming _RenderingContext
    ) {
        html._attributes.append(context.attributes)
        renderer.appendToken(.startTag(Tag.name, attributes: html._attributes.flattened(), isUnpaired: true, type: Tag.renderingType))
    }

    #if !hasFeature(Embedded)
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
    #endif
}

extension HTMLComment {
    @inlinable
    public static func _render<Renderer: _HTMLRendering>(
        _ html: consuming Self,
        into renderer: inout Renderer,
        with context: consuming _RenderingContext
    ) {
        context.assertNoAttributes(self)
        renderer.appendToken(.comment(html.text))
    }

    #if !hasFeature(Embedded)
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
    #endif
}

extension HTMLRaw {
    @inlinable
    public static func _render<Renderer: _HTMLRendering>(
        _ html: consuming Self,
        into renderer: inout Renderer,
        with context: consuming _RenderingContext
    ) {
        context.assertNoAttributes(self)
        renderer.appendToken(.raw(html.text))
    }

    #if !hasFeature(Embedded)
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
    #endif
}

