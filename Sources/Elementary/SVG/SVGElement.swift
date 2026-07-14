/// An SVG element that can contain SVG content.
public struct SVGElement<Tag: SVGTagDefinition, Content: SVGContent>: _Attributed, SVGContent {
    public typealias Body = Never

    public var _attributes: _AttributeStorage

    /// The content of the element.
    public var content: Content

    /// Creates a new SVG element with the specified content.
    @inlinable
    public init(@ContentBuilder content: () -> Content) {
        self._attributes = .init()
        self.content = content()
    }

    /// Creates a new SVG element with the specified attribute and content.
    @inlinable
    public init(_ attribute: SVGAttribute<Tag>, @ContentBuilder content: () -> Content) {
        self._attributes = .init(attribute)
        self.content = content()
    }

    /// Creates a new SVG element with the specified attributes and content.
    @inlinable
    public init(_ attributes: SVGAttribute<Tag>..., @ContentBuilder content: () -> Content) {
        self._attributes = .init(attributes)
        self.content = content()
    }

    /// Creates a new SVG element with the specified attributes and content.
    @inlinable
    public init(attributes: [SVGAttribute<Tag>], @ContentBuilder content: () -> Content) {
        self._attributes = .init(attributes)
        self.content = content()
    }
}

public extension SVGElement where Content == EmptyContent {
    /// Creates a new empty SVG element.
    @inlinable
    init() {
        self._attributes = .init()
        self.content = EmptyContent()
    }

    /// Creates a new empty SVG element with the specified attribute.
    @inlinable
    init(_ attribute: SVGAttribute<Tag>) {
        self._attributes = .init(attribute)
        self.content = EmptyContent()
    }

    /// Creates a new empty SVG element with the specified attributes.
    @inlinable
    init(_ attributes: SVGAttribute<Tag>...) {
        self._attributes = .init(attributes)
        self.content = EmptyContent()
    }

    /// Creates a new empty SVG element with the specified attributes.
    @inlinable
    init(attributes: [SVGAttribute<Tag>]) {
        self._attributes = .init(attributes)
        self.content = EmptyContent()
    }
}

extension SVGElement: Sendable where Content: Sendable {}

extension SVGElement: HTML where Tag == SVGTag.svg {}
