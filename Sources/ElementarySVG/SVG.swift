import Elementary

/// A type that represents SVG content that can be rendered.
///
/// You can create reusable SVG components by conforming to this protocol
/// and implementing the ``body`` property.
///
/// ```swift
/// struct Checkmark: SVGContent {
///   var body: some SVGContent {
///     SVG.path(.d("M20 6 9 17l-5-5"))
///   }
/// }
/// ```
public protocol SVGContent<Tag>: MarkupContent where Tag: SVGTagDefinition, Body: SVGContent {
    var _isKnownEmpty: Bool { get }
}

public extension SVGContent {
    @inlinable
    var _isKnownEmpty: Bool { false }
}

/// A namespace for SVG element types.
///
/// For the protocol counterpart of HTML, see ``SVGContent``.
public enum SVG {}

/// A namespace for SVG tag definitions.
public enum SVGTag {}

/// A type that represents an SVG tag.
public protocol SVGTagDefinition: MarkupTagDefinition, MarkupTrait.AllowsAttributes {}

/// An SVG attribute that can be applied to an SVG element of the associated tag.
public typealias SVGAttribute = MarkupAttribute

extension Never: SVGTagDefinition {}

extension _AttributedContent: SVGContent where Content: SVGContent {}
