/// An internal type that stores HTML attributes for elements.
///
/// Attributes are stored in a flat list in the order they were added. Attributes with the same name are merged
/// into the first occurrence (according to their merge mode) when iterating or rendering.
///
/// The storage avoids allocations for zero or one attribute, and merging never mutates or copies the stored list.
public struct _AttributeStorage: Sendable, Equatable {
    @usableFromInline
    enum Storage: Sendable, Equatable {
        case none
        case single(_StoredAttribute)
        case list([_StoredAttribute])
    }

    @usableFromInline
    var storage: Storage

    @inlinable
    init(storage: Storage) {
        self.storage = storage
    }

    @inlinable
    public static var none: Self { .init(storage: .none) }

    @inlinable
    public init() {
        self.init(storage: .none)
    }

    @inlinable
    public init(_ attribute: MarkupAttribute<some MarkupTagDefinition>) {
        self.init(storage: .single(attribute.htmlAttribute))
    }

    @inlinable
    public init(_ attributes: [MarkupAttribute<some MarkupTagDefinition>]) {
        switch attributes.count {
        case 0: self.init(storage: .none)
        case 1: self.init(storage: .single(attributes[0].htmlAttribute))
        default: self.init(storage: .list(attributes.map { $0.htmlAttribute }))
        }
    }

    @inlinable
    public var isEmpty: Bool {
        switch storage {
        case .none: return true
        case .single: return false
        case let .list(attributes): return attributes.isEmpty
        }
    }

    /// Appends the attributes of `other`, to be merged into the existing ones.
    public mutating func append(_ other: consuming _AttributeStorage) {
        switch other.storage {
        case .none:
            return
        case let .single(attribute):
            appendAttributes(single: attribute)
        case let .list(attributes):
            appendAttributes(list: attributes)
        }
    }

    private mutating func appendAttributes(single attribute: consuming _StoredAttribute) {
        switch storage {
        case .none:
            storage = .single(attribute)
        case let .single(existing):
            storage = .list([existing, attribute])
        case var .list(existing):
            storage = .none  // keep unique
            existing.append(attribute)
            storage = .list(existing)
        }
    }

    private mutating func appendAttributes(list attributes: consuming [_StoredAttribute]) {
        switch storage {
        case .none:
            storage = .list(attributes)
        case let .single(existing):
            var combined = [_StoredAttribute]()
            combined.reserveCapacity(attributes.count + 1)
            combined.append(existing)
            combined.append(contentsOf: attributes)
            storage = .list(combined)
        case var .list(existing):
            storage = .none  // keep unique
            existing.append(contentsOf: attributes)
            storage = .list(existing)
        }
    }

    public consuming func flattened() -> _MergedAttributes {
        .init(storage: self)
    }
}

extension _AttributeStorage {
    /// Calls `body` for every merged attribute in rendering order.
    ///
    /// Attributes that do not need merging are passed directly from storage without copying.
    @inline(__always)
    func forEachMerged(_ body: (borrowing _StoredAttribute) -> Void) {
        switch storage {
        case .none:
            return
        case let .single(attribute):
            body(attribute)
        case let .list(attributes):
            attributes.withUnsafeBufferPointer { attributes in
                var consumed = _ConsumedSet()
                for index in attributes.indices where !consumed.contains(index) {
                    if let match = Self.nextMatch(for: index, from: index &+ 1, in: attributes, consumed: consumed) {
                        body(Self.merge(at: index, firstMatch: match, in: attributes, consumed: &consumed))
                    } else {
                        body(attributes[index])
                    }
                }
            }
        }
    }

    /// Returns the index of the next unconsumed attribute (starting at `start`) with the same name as the attribute at `index`.
    @inline(__always)
    static func nextMatch(
        for index: Int,
        from start: Int,
        in attributes: UnsafeBufferPointer<_StoredAttribute>,
        consumed: borrowing _ConsumedSet
    ) -> Int? {
        guard start < attributes.count else { return nil }
        let nameCount = attributes[index].name.utf8.count

        var other = start
        while other < attributes.count {
            if attributes[other].name.utf8.count == nameCount,
                !consumed.contains(other),
                attributes[other].name.utf8Equals(attributes[index].name)
            {
                return other
            }
            other &+= 1
        }
        return nil
    }

    /// Merges all later attributes with the same name into the attribute at `index`, marking them as consumed.
    static func merge(
        at index: Int,
        firstMatch: Int,
        in attributes: UnsafeBufferPointer<_StoredAttribute>,
        consumed: inout _ConsumedSet
    ) -> _StoredAttribute {
        var merged = attributes[index]
        var match: Int? = firstMatch
        while let other = match {
            consumed.insert(other)
            merged.mergeWith(attributes[other])
            match = nextMatch(for: index, from: other &+ 1, in: attributes, consumed: consumed)
        }
        return merged
    }
}

/// A small bit set to track merged attributes, inline for up to 64 attributes.
struct _ConsumedSet {
    var inline: UInt64 = 0
    var overflow: [UInt64] = []

    @inline(__always)
    func contains(_ index: Int) -> Bool {
        if index < 64 { return inline & (1 &<< UInt64(index)) != 0 }
        let word = (index &- 64) / 64
        guard word < overflow.count else { return false }
        return overflow[word] & (1 &<< UInt64((index &- 64) % 64)) != 0
    }

    @inline(__always)
    mutating func insert(_ index: Int) {
        if index < 64 {
            inline |= 1 &<< UInt64(index)
            return
        }
        let word = (index &- 64) / 64
        while overflow.count <= word { overflow.append(0) }
        overflow[word] |= 1 &<< UInt64((index &- 64) % 64)
    }
}

public struct _MergedAttributes: Sequence, Sendable {
    public typealias Element = _StoredAttribute
    @usableFromInline
    var storage: _AttributeStorage

    @inlinable
    init(storage: consuming _AttributeStorage) {
        self.storage = storage
    }

    public consuming func makeIterator() -> Iterator {
        Iterator(storage)
    }

    public var isEmpty: Bool {
        storage.isEmpty
    }

    @inline(__always)
    func forEachMerged(_ body: (borrowing _StoredAttribute) -> Void) {
        storage.forEachMerged(body)
    }

    public struct Iterator: IteratorProtocol {
        let storage: _AttributeStorage
        var index: Int = 0
        var consumed = _ConsumedSet()

        init(_ storage: consuming _AttributeStorage) {
            self.storage = storage
        }

        public mutating func next() -> _StoredAttribute? {
            switch storage.storage {
            case .none:
                return nil
            case let .single(attribute):
                guard index == 0 else { return nil }
                index = 1
                return attribute
            case let .list(attributes):
                while index < attributes.count, consumed.contains(index) {
                    index &+= 1
                }
                guard index < attributes.count else { return nil }
                defer { index &+= 1 }

                return attributes.withUnsafeBufferPointer { attributes in
                    if let match = _AttributeStorage.nextMatch(for: index, from: index &+ 1, in: attributes, consumed: consumed) {
                        return _AttributeStorage.merge(at: index, firstMatch: match, in: attributes, consumed: &consumed)
                    }
                    return attributes[index]
                }
            }
        }
    }
}
