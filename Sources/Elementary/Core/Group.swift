/// A container that groups HTML content without introducing any additional HTML tags.
///
/// This type is useful when you want to return multiple sibling nodes from a single `some HTML`
/// context without adding an extra wrapper element.
///
/// - Note: In Embedded mode, the HTML builder currently supports up to **6 direct child views**
///   in a single block (because variadic generics aren't available there yet). You can exceed
///   that limit by nesting content inside one or more `Group` blocks.
public struct Group<Content: HTML>: HTML {
    public typealias Tag = Never
    public typealias Body = Never
    public typealias Content = Content

    public let content: Content

    @inlinable
    public init(@HTMLBuilder content: () -> Content) {
        self.content = content()
    }

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
