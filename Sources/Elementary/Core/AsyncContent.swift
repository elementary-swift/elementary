/// A container that awaits its content.
///
/// When its content is HTML, this element can only be rendered in an async context (ie: by calling
/// ``HTML/render(into:chunkSize:)`` or ``HTML/renderAsync()``).
/// All HTML tag types (``HTMLElement``) support async content closures in their initializers, so you don't need to use this element directly in most cases.
@_unavailableInEmbedded
public struct AsyncContent<Content>: Sendable {
    @usableFromInline
    var content: @Sendable () async throws -> Content

    /// Creates a new async container with the specified content.
    ///
    /// - Parameters:
    ///   - content: The future content of the element.
    ///
    /// ```swift
    /// AsyncContent {
    ///    let value = await fetchValue()
    ///   "Waiting for "
    ///    span { value }
    /// }
    /// ```
    public init(@ContentBuilder content: @escaping @Sendable () async throws -> Content) {
        self.content = content
    }
}

extension AsyncContent: HTML where Content: HTML {
    public typealias Body = Never
    public typealias Tag = Content.Tag

    @inlinable
    public static func _render<Renderer: _HTMLRendering>(
        _ html: consuming Self,
        into renderer: inout Renderer,
        with context: consuming _RenderingContext
    ) {
        context.assertionFailureNoAsyncContext(self)
    }

    @inlinable
    @_unavailableInEmbedded
    public static func _render<Renderer: _AsyncHTMLRendering>(
        _ html: consuming Self,
        into renderer: inout Renderer,
        with context: consuming _RenderingContext
    ) async throws {
        try await Content._render(await html.content(), into: &renderer, with: context)
    }
}
