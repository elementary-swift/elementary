public struct _AttributedContent<Content: MarkupContent>: MarkupContent {
    public typealias Body = Never
    public typealias Tag = Content.Tag

    public var content: Content

    public var _attributes: _AttributeStorage

    @inlinable
    public init(content: Content) {
        self.content = content
        self._attributes = .init()
    }

    @inlinable
    public init(content: Content, attribute: MarkupAttribute<Tag>) {
        self.content = content
        self._attributes = .init(attribute)
    }

    @inlinable
    public init(content: Content, attributes: [MarkupAttribute<Tag>]) {
        self.content = content
        self._attributes = .init(attributes)
    }

    @inlinable
    public init(content: Content, attributes: _AttributeStorage) {
        self.content = content
        self._attributes = attributes
    }
}

extension _AttributedContent: Sendable where Content: Sendable {}
extension _AttributedContent: _Attributed {}

public protocol _Attributed {
    var _attributes: _AttributeStorage { get set }
}

public extension MarkupContent where Self: _Attributed {
    /// Adds the specified attribute to the element.
    /// - Parameters:
    ///   - attribute: The attribute to add to the element.
    ///   - condition: If set to false, the attribute will not be added.
    /// - Returns: A new element with the specified attribute added.
    @inlinable
    func attributes(_ attribute: MarkupAttribute<Tag>, when condition: Bool = true) -> Self {
        if condition {
            var element = self
            element._attributes.append(_AttributeStorage(attribute))
            return element
        } else {
            return self
        }
    }

    /// Adds the specified attributes to the element.
    /// - Parameters:
    ///   - attributes: The attributes to add to the element.
    ///   - condition: If set to false, the attributes will not be added.
    /// - Returns: A new element with the specified attributes added.
    @inlinable
    func attributes(_ attributes: MarkupAttribute<Tag>..., when condition: Bool = true) -> Self {
        self.attributes(contentsOf: attributes, when: condition)
    }

    /// Adds the specified attributes to the element.
    /// - Parameters:
    ///   - attributes: The attributes to add to the element as an array.
    ///   - condition: If set to false, the attributes will not be added.
    /// - Returns: A new element with the specified attributes added.
    @inlinable
    func attributes(contentsOf attributes: [MarkupAttribute<Tag>], when condition: Bool = true) -> Self {
        if condition {
            var element = self
            element._attributes.append(_AttributeStorage(attributes))
            return element
        } else {
            return self
        }
    }
}

public extension MarkupContent where Tag: MarkupTrait.AllowsAttributes {
    /// Adds the specified attribute to the element.
    /// - Parameters:
    ///   - attribute: The attribute to add to the element.
    ///   - condition: If set to false, the attribute will not be added.
    /// - Returns: A new element with the specified attribute added.
    @inlinable @_disfavoredOverload
    func attributes(_ attribute: MarkupAttribute<Tag>, when condition: Bool = true) -> _AttributedContent<Self> {
        if condition {
            return _AttributedContent(content: self, attribute: attribute)
        } else {
            return _AttributedContent(content: self)
        }
    }

    /// Adds the specified attributes to the element.
    /// - Parameters:
    ///   - attributes: The attributes to add to the element.
    ///   - condition: If set to false, the attributes will not be added.
    /// - Returns: A new element with the specified attributes added.
    @inlinable @_disfavoredOverload
    func attributes(_ attributes: MarkupAttribute<Tag>..., when condition: Bool = true) -> _AttributedContent<Self> {
        _AttributedContent(content: self, attributes: condition ? attributes : [])
    }

    /// Adds the specified attributes to the element.
    /// - Parameters:
    ///   - attributes: The attributes to add to the element as an array.
    ///   - condition: If set to false, the attributes will not be added.
    /// - Returns: A new element with the specified attributes added.
    @inlinable @_disfavoredOverload
    func attributes(contentsOf attributes: [MarkupAttribute<Tag>], when condition: Bool = true) -> _AttributedContent<Self> {
        _AttributedContent(content: self, attributes: condition ? attributes : [])
    }
}
