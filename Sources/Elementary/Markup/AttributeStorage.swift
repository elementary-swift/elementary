/// An internal type that stores HTML attributes for elements.
///
/// Attributes are stored in the order they were added. Attributes with the same name are merged into the
/// first occurrence (according to their merge mode) when iterating or rendering.
///
/// The storage avoids allocations for zero or one attribute, and merging never mutates or copies the stored list.
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
        default: self = .multiple(attributes.map { $0.htmlAttribute })
        }
    }

    public var isEmpty: Bool {
        switch self {
        case .none: return true
        case .single: return false
        case let .multiple(attributes): return attributes.isEmpty  // just to be sure...
        }
    }

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
        case let .single(existing):
            self = .multiple([existing, attribute])
        case var .multiple(existing):
            // release our reference first, so the array is uniquely referenced and appended to in place
            self = .none
            existing.append(attribute)
            self = .multiple(existing)
        }
    }

    private mutating func append(contentsOf attributes: consuming [_StoredAttribute]) {
        switch self {
        case .none:
            self = .multiple(attributes)
        case let .single(existing):
            var combined: [_StoredAttribute] = []
            combined.reserveCapacity(attributes.count + 1)
            combined.append(existing)
            combined.append(contentsOf: attributes)
            self = .multiple(combined)
        case var .multiple(existing):
            // release our reference first, so the array is uniquely referenced and appended to in place
            self = .none
            existing.append(contentsOf: attributes)
            self = .multiple(existing)
        }
    }

    public consuming func flattened() -> _MergedAttributes {
        .init(storage: self)
    }
}

extension _AttributeStorage {
    /// Calls `body` for every merged attribute, in order of first occurrence.
    ///
    /// Attributes that do not need merging are passed directly from storage without copying.
    @inline(__always)
    func forEachMerged(_ body: (borrowing _StoredAttribute) -> Void) {
        switch self {
        case .none:
            return
        case let .single(attribute):
            body(attribute)
        case let .multiple(attributes):
            attributes.withUnsafeBufferPointer { attributes in
                var merged = AttributeIndexSet()
                for index in attributes.indices where !merged.contains(index) {
                    if let match = Self.nextMatch(for: index, from: index + 1, in: attributes, skipping: merged) {
                        body(Self.merge(at: index, firstMatch: match, in: attributes, merged: &merged))
                    } else {
                        body(attributes[index])
                    }
                }
            }
        }
    }

    /// Returns the index of the next attribute at or after `start` that has the same name as the attribute at `index`.
    @inline(__always)
    static func nextMatch(
        for index: Int,
        from start: Int,
        in attributes: UnsafeBufferPointer<_StoredAttribute>,
        skipping merged: borrowing AttributeIndexSet
    ) -> Int? {
        guard start < attributes.count else { return nil }

        // NOTE: names are always accessed in place, binding them to a local would add retain/release traffic
        let nameLength = attributes[index].name.utf8.count

        // NOTE: this is the hot loop of attribute merging, a plain while loop is measurably faster than iterating a range
        var other = start
        while other < attributes.count {
            // comparing lengths first is cheap and rules out almost all mismatches
            if attributes[other].name.utf8.count == nameLength,
                !merged.contains(other),
                attributes[other].name.utf8Equals(attributes[index].name)
            {
                return other
            }
            other &+= 1
        }

        return nil
    }

    /// Merges all attributes from `firstMatch` onward that have the same name into the attribute at `index`.
    static func merge(
        at index: Int,
        firstMatch: Int,
        in attributes: UnsafeBufferPointer<_StoredAttribute>,
        merged: inout AttributeIndexSet
    ) -> _StoredAttribute {
        var result = attributes[index]
        var match: Int? = firstMatch

        while let other = match {
            merged.insert(other)
            result.mergeWith(attributes[other])
            match = nextMatch(for: index, from: other + 1, in: attributes, skipping: merged)
        }

        return result
    }
}

/// Tracks attribute indices that have already been merged into an earlier attribute.
///
/// Indices below 64 are stored inline, so typical elements never allocate.
///
/// NOTE: all shift amounts are below 64, so masking shifts (`&<<`) are used to skip overshift handling.
struct AttributeIndexSet {
    private var inline: UInt64 = 0
    private var overflow: [UInt64] = []

    @inline(__always)
    func contains(_ index: Int) -> Bool {
        if index < 64 {
            return inline & (1 &<< UInt64(index)) != 0
        }

        let word = index / 64 - 1
        return word < overflow.count && overflow[word] & (1 &<< UInt64(index % 64)) != 0
    }

    @inline(__always)
    mutating func insert(_ index: Int) {
        if index < 64 {
            inline |= 1 &<< UInt64(index)
            return
        }

        let word = index / 64 - 1
        if word >= overflow.count {
            overflow.append(contentsOf: repeatElement(0, count: word - overflow.count + 1))
        }
        overflow[word] |= 1 &<< UInt64(index % 64)
    }
}

public struct _MergedAttributes: Sequence, Sendable {
    public typealias Element = _StoredAttribute
    var storage: _AttributeStorage

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
        var index = 0
        var merged = AttributeIndexSet()

        init(_ storage: consuming _AttributeStorage) {
            self.storage = storage
        }

        public mutating func next() -> _StoredAttribute? {
            switch storage {
            case .none:
                return nil
            case let .single(attribute):
                guard index == 0 else { return nil }
                index = 1
                return attribute
            case let .multiple(attributes):
                while index < attributes.count, merged.contains(index) {
                    index += 1
                }
                guard index < attributes.count else { return nil }
                defer { index += 1 }

                return attributes.withUnsafeBufferPointer { attributes in
                    if let match = _AttributeStorage.nextMatch(for: index, from: index + 1, in: attributes, skipping: merged) {
                        return _AttributeStorage.merge(at: index, firstMatch: match, in: attributes, merged: &merged)
                    } else {
                        return attributes[index]
                    }
                }
            }
        }
    }
}
