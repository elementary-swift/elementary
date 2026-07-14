/// A type that represents a markup tag.
public protocol MarkupTagDefinition: Sendable {
    /// The name of the tag as it is rendered in a document.
    static var name: String { get }
}

/// A namespace for shared markup traits.
public enum MarkupTrait {
    /// A marker that indicates that a markup tag can have attributes.
    public protocol AllowsAttributes {}
}

extension Never: MarkupTagDefinition {
    public static var name: String { fatalError("MarkupTag.name was called on Never") }
}
