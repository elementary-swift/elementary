/// A type that represents a markup tag.
public protocol MarkupTagDefinition: Sendable {
    /// The name of the tag as it is rendered in a document.
    static var name: String { get }

    /// Internal property that controls formatted rendering of the element (inline or block).
    ///
    /// A default implementation is provided that returns `false`.
    static var _rendersInline: Bool { get }
}

extension Never: MarkupTagDefinition {
    public static var name: String { fatalError("MarkupTag.name was called on Never") }
}

public extension MarkupTagDefinition {
    @inlinable
    static var _rendersInline: Bool { false }
}

extension MarkupTagDefinition {
    @inlinable
    static var renderingType: _HTMLRenderToken.RenderingType {
        _rendersInline ? .inline : .block
    }
}
