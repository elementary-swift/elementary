/// An HTML attribute that can be applied to an HTML element of the associated tag.
public typealias HTMLAttribute<Tag: HTMLTagDefinition> = MarkupAttribute<Tag>

/// The action to take when merging an attribute with the same name.
public typealias HTMLAttributeMergeAction = MarkupAttributeMergeAction

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
