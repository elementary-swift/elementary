/// A value that pairs content with a modifier.
///
/// The generic parameters are unconstrained, allowing other libraries to use this
/// storage type for their own content and modifiers. Markup conformances are
/// provided when the content is markup, the modifier supports markup rendering,
/// and the content's tag matches the modifier's input tag. The resulting tag is
/// defined by the modifier.
/// The value is `Sendable` when both stored values are `Sendable`.
public struct ModifiedContent<Content, Modifier> {
    /// The content being modified.
    public var content: Content

    /// The modifier applied to the content.
    public var modifier: Modifier

    /// Creates a value with the specified content and modifier.
    @inlinable
    public init(content: Content, modifier: Modifier) {
        self.content = content
        self.modifier = modifier
    }
}

extension ModifiedContent: Sendable where Content: Sendable, Modifier: Sendable {}
