/// Low-level rendering support for markup modifiers.
///
/// Conforming modifiers control how ``ModifiedContent`` renders its wrapped content.
/// Implement both rendering requirements to transform or delegate rendering of
/// the content, passing on the appropriate context. This underscored contract may evolve as
/// additional modifier APIs are introduced.
///
/// In Embedded Swift, this protocol has no rendering requirements.
public protocol _MarkupRenderingModifier {
    /// The tag accepted by this modifier's rendering implementation.
    ///
    /// Rendering requires an exact tag match, including when this type is `Never`.
    /// The wildcard behavior of ``HTMLModifier`` is provided by ``HTML/modifier(_:)``.
    associatedtype InputTag: MarkupTagDefinition

    /// The tag describing the markup produced by this modifier.
    ///
    /// Tag-preserving modifiers use the wrapped content's tag. Modifiers that
    /// change the rendered structure declare the tag of their resulting markup.
    associatedtype Tag: MarkupTagDefinition

    #if !hasFeature(Embedded)
    /// Renders the wrapped content synchronously using this modifier.
    /// - Parameters:
    ///   - content: The wrapped content to render.
    ///   - renderer: The renderer that receives the content's output.
    ///   - context: The rendering context inherited from the surrounding content.
    consuming func _render<Content: MarkupContent, Renderer: _HTMLRendering>(
        _ content: consuming Content,
        into renderer: inout Renderer,
        with context: consuming _RenderingContext
    ) where Content.Tag == InputTag

    /// Renders the wrapped content asynchronously using this modifier.
    /// - Parameters:
    ///   - content: The wrapped content to render.
    ///   - renderer: The renderer that receives the content's output.
    ///   - context: The rendering context inherited from the surrounding content.
    ///
    /// - Throws: Errors from rendering the content or writing to the renderer.
    @_unavailableInEmbedded
    consuming func _render<Content: MarkupContent, Renderer: _AsyncHTMLRendering>(
        _ content: consuming Content,
        into renderer: inout Renderer,
        with context: consuming _RenderingContext
    ) async throws where Content.Tag == InputTag
    #endif
}
