/// A markup attribute that can be applied to an element of the associated tag.
public struct MarkupAttribute<Tag: MarkupTagDefinition>: Sendable {
    @usableFromInline
    var htmlAttribute: _StoredAttribute

    /// The name of the attribute.
    public var name: String { htmlAttribute.name }

    /// The value of the attribute.
    public var value: String? { htmlAttribute.value }
}

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
