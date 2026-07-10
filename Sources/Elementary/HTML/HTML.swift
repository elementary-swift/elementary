/// A type that represents HTML content that can be rendered.
///
/// You can create reusable HTML components by conforming to this protocol
/// and implementing the ``body`` property.
///
/// ```swift
/// struct FeatureList: HTML {
///   var features: [String]
///
///   var body: some HTML {
///     ul {
///       for feature in features {
///         li { feature }
///       }
///     }
///   }
/// }
/// ```
public protocol HTML<Tag>: MarkupContent where Tag: HTMLTagDefinition, Body: HTML {}

/// A type that represents an HTML tag.
public protocol HTMLTagDefinition: MarkupTagDefinition {
    /// Internal property that controls formatted rendering of the element (inline or block).
    ///
    /// A default implementation is provided that returns `false`.
    static var _rendersInline: Bool { get }
}

extension Never: HTMLTagDefinition {}

public extension HTMLTagDefinition {
    @inlinable
    static var _rendersInline: Bool { false }
}

public extension HTMLTagDefinition where Self: HTMLTrait.RenderedInline {
    static var _rendersInline: Bool { true }
}

/// Compatibility alias for ``ContentBuilder``.
///
/// Prefer ``ContentBuilder`` for new code. This alias is kept for source compatibility and will eventually be deprecated and removed.
public typealias HTMLBuilder = ContentBuilder

/// Compatibility alias for ``EmptyContent``.
///
/// Prefer ``EmptyContent`` for new code. This alias is kept for source compatibility and will eventually be deprecated and removed.
public typealias EmptyHTML = EmptyContent

/// Compatibility alias for ``StringContent``.
///
/// Prefer ``StringContent`` for new code. This alias is kept for source compatibility and will eventually be deprecated and removed.
public typealias HTMLText = StringContent

extension _AttributedElement: HTML where Tag: HTMLTagDefinition, Content: HTML {}

/// An HTML attribute that can be applied to an HTML element of the associated tag.
public typealias HTMLAttribute<Tag: HTMLTagDefinition> = MarkupAttribute<Tag>

/// The action to take when merging an attribute with the same name.
public typealias HTMLAttributeMergeAction = MarkupAttributeMergeAction

/// Deprecated compatibility alias for ``_ArrayContent``.
///
/// Prefer ``_ArrayContent`` for new code. This alias is kept for the upgrade path and will be removed in a future release.
@available(*, deprecated, renamed: "_ArrayContent")
public typealias _HTMLArray<Element> = _ArrayContent<Element>

/// Deprecated compatibility alias for ``_ConditionalContent``.
///
/// Prefer ``_ConditionalContent`` for new code. This alias is kept for the upgrade path and will be removed in a future release.
@available(*, deprecated, renamed: "_ConditionalContent")
public typealias _HTMLConditional<TrueContent, FalseContent> = _ConditionalContent<TrueContent, FalseContent>
