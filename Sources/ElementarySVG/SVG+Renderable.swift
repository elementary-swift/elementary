import Elementary

#if !hasFeature(Embedded)
extension SVGElement {
    @inlinable
    public static func _render<Renderer: _HTMLRendering>(
        _ svg: consuming Self,
        into renderer: inout Renderer,
        with context: consuming _RenderingContext
    ) {
        svg._attributes.append(context.attributes)

        renderer.appendToken(.startTag(Tag.name, attributes: svg._attributes.flattened(), isUnpaired: false, type: .block))
        Content._render(svg.content, into: &renderer, with: .emptyContext)
        renderer.appendToken(.endTag(Tag.name, type: .block))
    }

    @inlinable
    @_unavailableInEmbedded
    public static func _render<Renderer: _AsyncHTMLRendering>(
        _ svg: consuming Self,
        into renderer: inout Renderer,
        with context: consuming _RenderingContext
    ) async throws {
        svg._attributes.append(context.attributes)

        try await renderer.appendToken(
            .startTag(Tag.name, attributes: svg._attributes.flattened(), isUnpaired: false, type: .block)
        )
        try await Content._render(svg.content, into: &renderer, with: .emptyContext)
        try await renderer.appendToken(.endTag(Tag.name, type: .block))
    }
}
#endif
