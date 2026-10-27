/// A modifier that adds attributes while preserving the wrapped content's tag.
///
/// ``MarkupContent/attributes(_:when:)`` creates this modifier automatically.
/// During rendering, its attributes are prepended to the rendering context;
/// duplicate attributes retain the existing attribute-merging behavior.
public struct _AttributesModifier<WrappedContent: MarkupContent>: _MarkupRenderingModifier, Sendable {
    public typealias InputTag = WrappedContent.Tag
    public typealias Tag = WrappedContent.Tag

    /// The attributes added to the wrapped content during rendering.
    public var _attributes: _AttributeStorage

    /// Creates a modifier with the specified attribute storage.
    @inlinable
    public init(attributes: _AttributeStorage) {
        self._attributes = attributes
    }
}

/// Compatibility alias for attribute-modified content.
///
/// Extensions adding protocol conformances must explicitly constrain
/// `Content: MarkupContent` and `Modifier == _AttributesModifier<Content>`.
@available(*, deprecated, renamed: "ModifiedContent")
public typealias _AttributedContent<Content: MarkupContent> = ModifiedContent<Content, _AttributesModifier<Content>>

public extension ModifiedContent where Content: MarkupContent, Modifier == _AttributesModifier<Content> {
    /// Compatibility access to the attributes stored by the modifier.
    @inlinable
    var _attributes: _AttributeStorage {
        _read { yield modifier._attributes }
        _modify { yield &modifier._attributes }
    }

    /// Creates attribute-modified content using the legacy initializer.
    ///
    /// Use ``ModifiedContent/init(content:modifier:)`` with ``_AttributesModifier`` instead.
    @available(*, deprecated, message: "Use init(content:modifier:) with _AttributesModifier instead.")
    @inlinable
    init(content: Content) {
        self.init(content: content, modifier: .init(attributes: .init()))
    }

    /// Creates attribute-modified content using the legacy initializer.
    ///
    /// Use ``ModifiedContent/init(content:modifier:)`` with ``_AttributesModifier`` instead.
    @available(*, deprecated, message: "Use init(content:modifier:) with _AttributesModifier instead.")
    @inlinable
    init(content: Content, attribute: MarkupAttribute<Content.Tag>) {
        self.init(content: content, modifier: .init(attributes: .init(attribute)))
    }

    /// Creates attribute-modified content using the legacy initializer.
    ///
    /// Use ``ModifiedContent/init(content:modifier:)`` with ``_AttributesModifier`` instead.
    @available(*, deprecated, message: "Use init(content:modifier:) with _AttributesModifier instead.")
    @inlinable
    init(content: Content, attributes: [MarkupAttribute<Content.Tag>]) {
        self.init(content: content, modifier: .init(attributes: .init(attributes)))
    }

    /// Creates attribute-modified content using the legacy initializer.
    ///
    /// Use ``ModifiedContent/init(content:modifier:)`` with ``_AttributesModifier`` instead.
    @available(*, deprecated, message: "Use init(content:modifier:) with _AttributesModifier instead.")
    @inlinable
    init(content: Content, attributes: _AttributeStorage) {
        self.init(content: content, modifier: .init(attributes: attributes))
    }
}

extension ModifiedContent: _Attributed where Content: MarkupContent, Modifier == _AttributesModifier<Content> {}
