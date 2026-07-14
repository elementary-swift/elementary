/// A container that awaits its content.
///
/// When its content is rendered, this element can only be used in an async context (ie: by calling
/// ``HTML/render(into:chunkSize:)`` or ``HTML/renderAsync()`` for HTML roots).
/// Paired HTML and SVG elements support async content closures in their initializers, so you don't need to use this element directly in most cases.
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
