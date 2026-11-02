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
    func attributes(_ attribute: MarkupAttribute<Tag>, when condition: Bool = true) -> ModifiedContent<Self, _AttributesModifier<Self>> {
        if condition {
            return ModifiedContent(content: self, modifier: .init(attributes: .init(attribute)))
        } else {
            return ModifiedContent(content: self, modifier: .init(attributes: .init()))
        }
    }

    /// Adds the specified attributes to the element.
    /// - Parameters:
    ///   - attributes: The attributes to add to the element.
    ///   - condition: If set to false, the attributes will not be added.
    /// - Returns: A new element with the specified attributes added.
    @inlinable @_disfavoredOverload
    func attributes(_ attributes: MarkupAttribute<Tag>..., when condition: Bool = true) -> ModifiedContent<Self, _AttributesModifier<Self>>
    {
        ModifiedContent(content: self, modifier: .init(attributes: .init(condition ? attributes : [])))
    }

    /// Adds the specified attributes to the element.
    /// - Parameters:
    ///   - attributes: The attributes to add to the element as an array.
    ///   - condition: If set to false, the attributes will not be added.
    /// - Returns: A new element with the specified attributes added.
    @inlinable @_disfavoredOverload
    func attributes(
        contentsOf attributes: [MarkupAttribute<Tag>],
        when condition: Bool = true
    ) -> ModifiedContent<Self, _AttributesModifier<Self>> {
        ModifiedContent(content: self, modifier: .init(attributes: .init(condition ? attributes : [])))
    }
}
