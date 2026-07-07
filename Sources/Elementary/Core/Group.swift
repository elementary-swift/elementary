/// A container that groups content without adding a wrapper.
///
/// This type is useful when you want to return multiple sibling nodes from a single `some HTML`
/// context without adding an extra wrapper element.
///
/// - Note: In Embedded mode, the content builder currently supports up to **6 direct child content values**
///   in a single block (because variadic generics aren't available there yet). You can exceed
///   that limit by nesting content inside one or more `Group` blocks.
public struct Group<Content> {
    public typealias Content = Content

    public let content: Content

    @inlinable
    public init(@ContentBuilder content: () -> Content) {
        self.content = content()
    }
}

extension Group: HTML where Content: HTML {
    public typealias Tag = Never
    public typealias Body = Never

    @inlinable
    public static func _render<Renderer: _HTMLRendering>(
        _ html: consuming Self,
        into renderer: inout Renderer,
        with context: consuming _RenderingContext
    ) {
        context.assertNoAttributes(self)
        Content._render(html.content, into: &renderer, with: context)
    }

    @inlinable
    @_unavailableInEmbedded
    public static func _render<Renderer: _AsyncHTMLRendering>(
        _ html: consuming Self,
        into renderer: inout Renderer,
        with context: consuming _RenderingContext
    ) async throws {
        context.assertNoAttributes(self)
        try await Content._render(html.content, into: &renderer, with: context)
    }
}

extension Group: Sendable where Content: Sendable {}
