/// A markup element that can contain content.
public struct MarkupElement<Tag: MarkupTagDefinition, Content> {
    /// The type of the HTML tag this element represents.
    public typealias Tag = Tag
    public typealias Content = Content

    public var _attributes: _AttributeStorage

    // The content of the element.
    public var content: Content

    /// Creates a new markup element with the specified content.
    /// - Parameter content: The content of the element.
    @inlinable
    public init(@ContentBuilder content: () -> Content) {
        self._attributes = .init()
        self.content = content()
    }

    /// Creates a new markup element with the specified attribute and content.
    /// - Parameters:
    ///   - attribute: The attribute to apply to the element.
    ///   - content: The content of the element.
    @inlinable
    public init(_ attribute: MarkupAttribute<Tag>, @ContentBuilder content: () -> Content) {
        self._attributes = .init(attribute)
        self.content = content()
    }

    /// Creates a new markup element with the specified attributes and content.
    /// - Parameters:
    ///  - attributes: The attributes to apply to the element.
    ///  - content: The content of the element.
    @inlinable
    public init(_ attributes: MarkupAttribute<Tag>..., @ContentBuilder content: () -> Content) {
        self._attributes = .init(attributes)
        self.content = content()
    }

    /// Creates a new markup element with the specified attributes and content.
    /// - Parameters:
    ///  - attributes: The attributes to apply to the element as an array.
    ///  - content: The content of the element.
    @inlinable
    public init(attributes: [MarkupAttribute<Tag>], @ContentBuilder content: () -> Content) {
        self._attributes = .init(attributes)
        self.content = content()
    }
}

public extension MarkupElement where Content == EmptyContent {
    /// Creates a new empty paired markup element.
    @inlinable
    init() {
        self._attributes = .init()
        self.content = EmptyContent()
    }

    /// Creates a new empty paired markup element with the specified attribute.
    @inlinable
    init(_ attribute: MarkupAttribute<Tag>) {
        self._attributes = .init(attribute)
        self.content = EmptyContent()
    }

    /// Creates a new empty paired markup element with the specified attributes.
    @inlinable
    init(_ attributes: MarkupAttribute<Tag>...) {
        self._attributes = .init(attributes)
        self.content = EmptyContent()
    }

    /// Creates a new empty paired markup element with the specified attributes.
    @inlinable
    init(attributes: [MarkupAttribute<Tag>]) {
        self._attributes = .init(attributes)
        self.content = EmptyContent()
    }
}

extension MarkupElement: Sendable where Content: Sendable {}

extension MarkupElement: _Attributed {}

extension MarkupElement: MarkupContent where Content: MarkupContent {
    public typealias Body = Never
}
