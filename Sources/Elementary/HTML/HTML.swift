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
public protocol HTML<Tag>: MarkupContent, _Renderable where Tag: HTMLTagDefinition, Body: HTML {}

/// A type that represents an HTML tag.
public protocol HTMLTagDefinition: MarkupTagDefinition {}

extension Never: HTMLTagDefinition {}

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
