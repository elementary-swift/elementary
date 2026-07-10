/// A type that represents namespace-neutral markup content.
///
/// This protocol owns the shared `body` relationship used by concrete markup namespaces like HTML and SVG.
public protocol MarkupContent<Tag>: _Renderable {
    /// The markup tag this component represents, if any.
    associatedtype Tag: MarkupTagDefinition = Body.Tag

    /// The type of markup content this component represents.
    associatedtype Body: MarkupContent

    /// The markup content of this component.
    @ContentBuilder var body: Body { get }
}

public extension MarkupContent where Body == Never {
    var body: Never {
        #if hasFeature(Embedded)
        fatalError("content was called on an unsupported type")
        #else
        fatalError("content cannot be called on \(Self.self)")
        #endif
    }
}
