/// A markup attribute that can be applied to an element of the associated tag.
public struct MarkupAttribute<Tag: MarkupTagDefinition>: Sendable {
    @usableFromInline
    var htmlAttribute: _StoredAttribute

    /// The name of the attribute.
    public var name: String { htmlAttribute.name }

    /// The value of the attribute.
    public var value: String? { htmlAttribute.value }
}

/// An HTML attribute that can be applied to an HTML element of the associated tag.
public typealias HTMLAttribute<Tag: HTMLTagDefinition> = MarkupAttribute<Tag>

/// The action to take when merging an attribute with the same name.
public struct MarkupAttributeMergeAction: Sendable {
    @usableFromInline
    var mergeMode: _StoredAttribute.MergeMode

    init(mergeMode: _StoredAttribute.MergeMode) {
        self.mergeMode = mergeMode
    }

    /// Replaces the value of the existing attribute with the new value.
    public static var replacing: Self { .init(mergeMode: .replaceValue) }

    /// Ignores the new value if the attribute already exists.
    public static var ignoring: Self { .init(mergeMode: .ignoreIfSet) }

    /// Appends the new value to the existing value, separated by the specified string.
    public static func appending(separatedBy: String) -> Self { .init(mergeMode: .appendValue(separatedBy)) }
}

/// The action to take when merging an attribute with the same name.
public typealias HTMLAttributeMergeAction = MarkupAttributeMergeAction

extension MarkupAttribute {
    /// Creates a new markup attribute with the specified name and value.
    /// - Parameters:
    ///   - name: The name of the attribute.
    ///   - value: The value of the attribute.
    ///   - action: The merge action to use with a previously attached attribute with the same name.
    @inlinable
    public init(name: String, value: String?, mergedBy action: MarkupAttributeMergeAction = .replacing) {
        htmlAttribute = .init(name: name, value: value, mergeMode: action.mergeMode)
    }

    /// Changes the default merge action of this attribute.
    /// - Parameter action: The new merge action to use.
    /// - Returns: A modified attribute with the specified merge action.
    @inlinable
    public consuming func mergedBy(_ action: MarkupAttributeMergeAction) -> MarkupAttribute {
        .init(name: name, value: value, mergedBy: action)
    }

    @inlinable
    init(classes: _StoredAttribute.Classes) {
        htmlAttribute = .init(classes)
    }

    @inlinable
    init(styles: _StoredAttribute.Styles) {
        htmlAttribute = .init(styles)
    }
}

public protocol _Attributed {
    associatedtype Tag: MarkupTagDefinition

    var _attributes: _AttributeStorage { get set }
}

public extension _Attributed {
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

public struct _AttributedElement<Tag: MarkupTagDefinition, Content>: _Attributed {
    public var content: Content

    @available(*, renamed: "_attributes")
    public var attributes: _AttributeStorage {
        _read { yield _attributes }
        _modify { yield &_attributes }
    }

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

extension _AttributedElement: _Renderable where Content: _Renderable {
    @inlinable
    public static func _render<Renderer: _HTMLRendering>(
        _ html: consuming Self,
        into renderer: inout Renderer,
        with context: consuming _RenderingContext
    ) {
        context.prependAttributes(html._attributes)
        Content._render(html.content, into: &renderer, with: context)
    }

    @inlinable
    @_unavailableInEmbedded
    public static func _render<Renderer: _AsyncHTMLRendering>(
        _ html: consuming Self,
        into renderer: inout Renderer,
        with context: consuming _RenderingContext
    ) async throws {
        context.prependAttributes(html._attributes)
        try await Content._render(html.content, into: &renderer, with: context)
    }
}

extension _AttributedElement: MarkupContent where Content: MarkupContent {
    public typealias Body = Never
}

extension _AttributedElement: HTML where Tag: HTMLTagDefinition, Content: HTML {}

extension _AttributedElement: Sendable where Content: Sendable {}

public extension HTML where Tag: HTMLTrait.Attributes.Global {
    /// Adds the specified attribute to the element.
    /// - Parameters:
    ///   - attribute: The attribute to add to the element.
    ///   - condition: If set to false, the attribute will not be added.
    /// - Returns: A new element with the specified attribute added.
    @inlinable @_disfavoredOverload
    func attributes(_ attribute: HTMLAttribute<Tag>, when condition: Bool = true) -> _AttributedElement<Tag, Self> {
        if condition {
            return _AttributedElement(content: self, attribute: attribute)
        } else {
            return _AttributedElement(content: self)
        }
    }

    /// Adds the specified attributes to the element.
    /// - Parameters:
    ///   - attributes: The attributes to add to the element.
    ///   - condition: If set to false, the attributes will not be added.
    /// - Returns: A new element with the specified attributes added.
    @inlinable @_disfavoredOverload
    func attributes(_ attributes: HTMLAttribute<Tag>..., when condition: Bool = true) -> _AttributedElement<Tag, Self> {
        _AttributedElement(content: self, attributes: condition ? attributes : [])
    }

    /// Adds the specified attributes to the element.
    /// - Parameters:
    ///   - attributes: The attributes to add to the element as an array.
    ///   - condition: If set to false, the attributes will not be added.
    /// - Returns: A new element with the specified attributes added.
    @inlinable @_disfavoredOverload
    func attributes(contentsOf attributes: [HTMLAttribute<Tag>], when condition: Bool = true) -> _AttributedElement<Tag, Self> {
        _AttributedElement(content: self, attributes: condition ? attributes : [])
    }
}

extension _RenderingContext {
    @usableFromInline
    mutating func prependAttributes(_ attributes: consuming _AttributeStorage) {
        attributes.append(self.attributes)
        self.attributes = attributes
    }
}
