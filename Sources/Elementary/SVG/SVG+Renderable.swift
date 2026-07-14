#if !hasFeature(Embedded)
extension SVGTagDefinition {
    @inlinable
    static var renderingType: _HTMLRenderToken.RenderingType {
        _svgRendersInline ? .inline : .block
    }
}

extension SVGElement {
    @inlinable
    public static func _render<Renderer: _HTMLRendering>(
        _ svg: consuming Self,
        into renderer: inout Renderer,
        with context: consuming _RenderingContext
    ) {
        svg._attributes.append(context.attributes)

        let attributes = svg._attributes.flattened()
        guard !svg.content._isKnownEmpty else {
            renderer.appendToken(.selfClosingTag(Tag.name, attributes: attributes))
            return
        }

        renderer.appendToken(.startTag(Tag.name, attributes: attributes, isUnpaired: false, type: Tag.renderingType))
        Content._render(svg.content, into: &renderer, with: .emptyContext)
        renderer.appendToken(.endTag(Tag.name, type: Tag.renderingType))
    }

    @inlinable
    @_unavailableInEmbedded
    public static func _render<Renderer: _AsyncHTMLRendering>(
        _ svg: consuming Self,
        into renderer: inout Renderer,
        with context: consuming _RenderingContext
    ) async throws {
        svg._attributes.append(context.attributes)

        let attributes = svg._attributes.flattened()
        guard !svg.content._isKnownEmpty else {
            try await renderer.appendToken(.selfClosingTag(Tag.name, attributes: attributes))
            return
        }

        try await renderer.appendToken(.startTag(Tag.name, attributes: attributes, isUnpaired: false, type: Tag.renderingType))
        try await Content._render(svg.content, into: &renderer, with: .emptyContext)
        try await renderer.appendToken(.endTag(Tag.name, type: Tag.renderingType))
    }
}
#endif
