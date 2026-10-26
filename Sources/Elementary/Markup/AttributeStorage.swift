/// An internal type that stores HTML attributes for elements.
///
/// Attributes are merged when they are added, so the storage always holds the final attributes (with unique names)
/// in the order of their first occurrence. Use `_withSpan` to read them.
///
/// The storage avoids allocations for zero or one attribute.
///
/// NOTE: all attributes in `.multiple` have unique names, every way of creating or extending the storage maintains this.
public enum _AttributeStorage: Sendable, Equatable {
    case none
    case single(_StoredAttribute)
    case multiple([_StoredAttribute])

    @inlinable
    public init() {
        self = .none
    }

    @inlinable
    public init(_ attribute: MarkupAttribute<some MarkupTagDefinition>) {
        self = .single(attribute.htmlAttribute)
    }

    @inlinable
    public init(_ attributes: [MarkupAttribute<some MarkupTagDefinition>]) {
        switch attributes.count {
        case 0: self = .none
        case 1: self = .single(attributes[0].htmlAttribute)
        default: self.init(merging: attributes.map { $0.htmlAttribute })
        }
    }

    /// Creates a storage from a list of attributes, merging attributes with the same name.
    @usableFromInline
    init(merging attributes: consuming [_StoredAttribute]) {
        // the common case: all names are unique, the list is stored as is
        guard let firstDuplicate = Self.firstDuplicate(in: attributes) else {
            self = .multiple(attributes)
            return
        }

        var merged = Array(attributes[..<firstDuplicate])
        merged.merge(contentsOf: attributes[firstDuplicate...])
        self = .multiple(merged)
    }

    public var isEmpty: Bool {
        switch self {
        case .none: return true
        case .single: return false
        case let .multiple(attributes): return attributes.isEmpty  // just to be sure...
        }
    }

    /// Merges the attributes of `other` into this storage, as if they were applied after the existing ones.
    public mutating func append(_ other: consuming _AttributeStorage) {
        switch other {
        case .none:
            return
        case let .single(attribute):
            append(attribute)
        case let .multiple(attributes):
            append(contentsOf: attributes)
        }
    }

    private mutating func append(_ attribute: consuming _StoredAttribute) {
        switch self {
        case .none:
            self = .single(attribute)
        case var .single(existing):
            if existing.name.utf8Equals(attribute.name) {
                existing.mergeWith(attribute)
                self = .single(existing)
            } else {
                self = .multiple([existing, attribute])
            }
        case var .multiple(existing):
            // release our reference first, so the array is uniquely referenced and modified in place
            self = .none
            existing.merge(attribute)
            self = .multiple(existing)
        }
    }

    /// Merges the attributes of another storage (so their names are already unique among themselves).
    private mutating func append(contentsOf attributes: consuming [_StoredAttribute]) {
        switch self {
        case .none:
            self = .multiple(attributes)
        case let .single(existing):
            var merged = [existing]
            merged.reserveCapacity(attributes.count + 1)
            merged.merge(contentsOf: attributes)
            self = .multiple(merged)
        case var .multiple(existing):
            // release our reference first, so the array is uniquely referenced and modified in place
            self = .none
            existing.merge(contentsOf: attributes)
            self = .multiple(existing)
        }
    }

    @available(*, deprecated, message: "Attributes are merged when they are added, use `_withSpan` to read them.")
    public consuming func flattened() -> _MergedAttributes {
        .init(self)
    }
}

extension _AttributeStorage {
    /// Calls `body` with a span of all attributes, in order (names are unique).
    ///
    /// NOTE: this is a stopgap for borrowing access to the attributes, to be replaced with borrowing iteration
    /// (`Iterable`) or a `span` property once they are available for all supported platforms and Swift versions.
    /// A `span` property currently can't cover `.single`, as enum payloads can't be borrowed in place (see SE-0551).
    @inlinable
    public func _withSpan<Result, Failure: Error>(
        _ body: (Span<_StoredAttribute>) throws(Failure) -> Result
    ) throws(Failure) -> Result {
        switch self {
        case .none:
            return try body(Span())
        case let .single(attribute):
            return try withUnsafePointer(to: attribute) { attribute throws(Failure) in
                try body(Span(_unsafeStart: attribute, count: 1))
            }
        case let .multiple(attributes):
            return try attributes.withUnsafeBufferPointer { attributes throws(Failure) in
                try body(Span(_unsafeElements: attributes))
            }
        }
    }

    /// Returns the index of the first attribute that has the same name as an earlier one.
    static func firstDuplicate(in attributes: borrowing [_StoredAttribute]) -> Int? {
        attributes.withUnsafeBufferPointer { attributes in
            var index = 1
            while index < attributes.count {
                if attributes.firstIndex(named: attributes[index].name, before: index) != nil {
                    return index
                }
                index &+= 1
            }
            return nil
        }
    }
}

extension [_StoredAttribute] {
    /// Merges `attribute` into the attribute with the same name, or appends it.
    mutating func merge(_ attribute: consuming _StoredAttribute) {
        let index = withUnsafeBufferPointer { $0.firstIndex(named: attribute.name, before: $0.count) }

        if let index {
            self[index].mergeWith(attribute)
        } else {
            append(attribute)
        }
    }

    /// Merges each of `attributes` in order, see `merge(_:)`.
    mutating func merge(contentsOf attributes: some Sequence<_StoredAttribute>) {
        for attribute in attributes {
            merge(attribute)
        }
    }
}

extension UnsafeBufferPointer<_StoredAttribute> {
    /// Returns the index of the attribute named `name` in `0..<end`.
    @inline(__always)
    func firstIndex(named name: borrowing String, before end: Int) -> Int? {
        let nameLength = name.utf8.count

        // NOTE: this is the hot loop of attribute merging, a plain while loop is measurably faster than iterating a range
        var index = 0
        while index < end {
            // comparing lengths first is cheap and rules out almost all mismatches
            if self[index].name.utf8.count == nameLength, self[index].name.utf8Equals(name) {
                return index
            }
            index &+= 1
        }

        return nil
    }
}

/// The attributes of a tag, as passed to renderers in `_HTMLRenderToken`.
///
/// NOTE: `_AttributeStorage` merges attributes when they are added, so this is only a view of an already merged storage.
/// It is kept for API compatibility, prefer `_withSpan` over iterating.
public struct _MergedAttributes: Sequence, Sendable {
    public typealias Element = _StoredAttribute
    @usableFromInline
    let storage: _AttributeStorage

    @inlinable
    init(_ storage: consuming _AttributeStorage) {
        self.storage = storage
    }

    public consuming func makeIterator() -> Iterator {
        Iterator(storage)
    }

    public var isEmpty: Bool {
        storage.isEmpty
    }

    /// Calls `body` with a span of all attributes, in order (names are unique).
    ///
    /// NOTE: a stopgap, see `_AttributeStorage._withSpan`.
    @inlinable
    public func _withSpan<Result, Failure: Error>(
        _ body: (Span<_StoredAttribute>) throws(Failure) -> Result
    ) throws(Failure) -> Result {
        try storage._withSpan(body)
    }

    public struct Iterator: IteratorProtocol {
        let storage: _AttributeStorage
        var index = 0

        init(_ storage: consuming _AttributeStorage) {
            self.storage = storage
        }

        public mutating func next() -> _StoredAttribute? {
            defer { index += 1 }

            switch storage {
            case .none:
                return nil
            case let .single(attribute):
                return index == 0 ? attribute : nil
            case let .multiple(attributes):
                return index < attributes.count ? attributes[index] : nil
            }
        }
    }
}
