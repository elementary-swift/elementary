/// An internal type representing a type-erased HTML attribute.
///
/// This type is used to store HTML attributes and their values of an element. It supports different types of values
/// like plain strings, styles, and classes, and provides different merge strategies when combining attributes.
///
/// The merge strategies control how attributes with the same name are combined:
/// - `.appendValue`: Appends values with a separator (default is space)
/// - `.replaceValue`: Replaces any existing value
/// - `.ignoreIfSet`: Keeps the existing value if present
///
/// Merging is associative, so attributes can be merged in any grouping (eg: modifiers before they reach an element)
/// with the same result. The only exception are repeated class names, which may be rendered once or repeatedly
/// depending on the grouping (resulting in the same set of classes).
public struct _StoredAttribute: Equatable, Sendable {
    @usableFromInline
    enum MergeMode: Equatable, Sendable {
        case appendValue(_ separator: String = " ")
        case replaceValue
        case ignoreIfSet

        @usableFromInline
        static func == (lhs: MergeMode, rhs: MergeMode) -> Bool {
            switch (lhs, rhs) {
            case let (.appendValue(lhsSeparator), .appendValue(rhsSeparator)): return lhsSeparator.utf8Equals(rhsSeparator)
            case (.replaceValue, .replaceValue): return true
            case (.ignoreIfSet, .ignoreIfSet): return true
            default:
                return false
            }
        }
    }

    @usableFromInline
    enum Value: Equatable, Sendable {
        case empty
        case plain(String)
        case styles(Styles)
        case classes(Classes)
        /// The result of merging an appending attribute into an ignoring one: renders as `value`, but only appends
        /// `suffix` when merged into an existing attribute.
        ///
        /// Only used with `.ignoreIfSet`, `suffix` is never empty.
        /// NOTE: this lives here and not in `MergeMode`, where a second payload would grow every attribute.
        indirect case ignoredWithSuffix(value: Value, separator: String, suffix: Value)

        var isEmpty: Bool {
            if case .empty = self { true } else { false }
        }

        @usableFromInline
        static func == (lhs: Value, rhs: Value) -> Bool {
            switch (lhs, rhs) {
            case (.empty, .empty): return true
            case let (.plain(lhsValue), .plain(rhsValue)): return lhsValue.utf8Equals(rhsValue)
            case let (.styles(lhsStyles), .styles(rhsStyles)): return lhsStyles == rhsStyles
            case let (.classes(lhsClasses), .classes(rhsClasses)): return lhsClasses == rhsClasses
            case let (.ignoredWithSuffix(lhsValue, lhsSeparator, lhsSuffix), .ignoredWithSuffix(rhsValue, rhsSeparator, rhsSuffix)):
                return lhsValue == rhsValue && lhsSeparator.utf8Equals(rhsSeparator) && lhsSuffix == rhsSuffix
            default: return false
            }
        }
    }

    public var name: String
    @usableFromInline
    var _value: Value

    // NOTE: this is mainly here to not break API for now
    public var value: String? {
        get { _value.flattened }
        set {
            _value = newValue.map { .plain($0) } ?? .empty
        }
    }

    @usableFromInline
    var mergeMode: MergeMode = .replaceValue

    @usableFromInline
    init(name: String, value: String? = nil, mergeMode: MergeMode = .replaceValue) {
        self.name = name
        self._value = value.map { .plain($0) } ?? .empty
        self.mergeMode = mergeMode
    }

    @usableFromInline
    init(_ styles: Styles) {
        self.name = "style"
        self._value = .styles(styles)
        self.mergeMode = .appendValue(";")
    }

    @usableFromInline
    init(_ classes: Classes) {
        self.name = "class"
        self._value = .classes(classes)
        self.mergeMode = .appendValue(" ")
    }

    /// Merges `attribute` into this one, as if it was applied after this attribute.
    ///
    /// The merge mode of the result describes how the combined attributes apply to an existing value, which makes
    /// merging associative: `(a ⊕ b) ⊕ c` equals `a ⊕ (b ⊕ c)`.
    mutating func mergeWith(_ attribute: consuming _StoredAttribute) {
        switch attribute.mergeMode {
        case .replaceValue:
            _value = attribute._value
            mergeMode = .replaceValue
        case .ignoreIfSet:
            if case let .ignoredWithSuffix(_, separator, suffix) = attribute._value {
                append(suffix, separator: separator)
            }
        case let .appendValue(separator):
            append(attribute._value, separator: separator)
        }
    }

    /// Appends `suffix` to the value, and updates the merge mode so the suffix is also appended to existing values.
    private mutating func append(_ suffix: Value, separator: String) {
        // appending nothing changes nothing, not even the separator
        guard !suffix.isEmpty else { return }

        switch (mergeMode, _value) {
        case (.replaceValue, _):
            _value = _value.appending(suffix, separator: separator)
        case (.appendValue, _):
            // without a value of our own, only the suffix (and its separator) is appended to an existing value
            if _value.isEmpty { mergeMode = .appendValue(separator) }
            _value = _value.appending(suffix, separator: separator)
        case let (.ignoreIfSet, .ignoredWithSuffix(value, ownSeparator, ownSuffix)):
            _value = .ignoredWithSuffix(
                value: value.appending(suffix, separator: separator),
                separator: ownSeparator,
                suffix: ownSuffix.appending(suffix, separator: separator)
            )
        case (.ignoreIfSet, _):
            _value = .ignoredWithSuffix(value: _value.appending(suffix, separator: separator), separator: separator, suffix: suffix)
        }
    }

    @inlinable
    public static func == (lhs: _StoredAttribute, rhs: _StoredAttribute) -> Bool {
        lhs.name.utf8Equals(rhs.name) && lhs._value == rhs._value && lhs.mergeMode == rhs.mergeMode
    }
}

extension _StoredAttribute.Value {
    /// The value as rendered, `nil` for boolean attributes.
    var flattened: String? {
        switch self {
        case .empty: return nil
        case let .plain(value): return value
        case let .styles(styles): return styles.flatten()
        case let .classes(classes): return classes.flatten()
        case let .ignoredWithSuffix(value, _, _): return value.flattened
        }
    }

    /// Returns this value with `other` appended (`separator` is only used between plain values).
    func appending(_ other: Self, separator: String) -> Self {
        switch (self, other) {
        case (_, .empty):
            return self
        case (.empty, _):
            return other
        case let (.plain(existing), .plain(other)):
            return .plain("\(existing)\(separator)\(other)")
        case (.styles(var existing), .styles(let other)):
            existing.append(contentsOf: other)
            return .styles(existing)
        case (.classes(var existing), .classes(let other)):
            existing.append(contentsOf: other)
            return .classes(existing)
        case let (.plain(existing), .styles(other)):
            var styles = _StoredAttribute.Styles(plainValue: existing)
            styles.append(contentsOf: other)
            return .styles(styles)
        case (.styles(var existing), .plain(let other)):
            existing.append(plainValue: other)
            return .styles(existing)
        case let (.plain(existing), .classes(other)):
            var classes = _StoredAttribute.Classes([existing])
            classes.append(contentsOf: other)
            return .classes(classes)
        case (.classes(var existing), .plain(let other)):
            existing.append(plainValue: other)
            return .classes(existing)
        case (.styles, .classes), (.classes, .styles):
            assertionFailure("Cannot merge styles and classes")
            // If trying to merge incompatible types, just replace
            return other
        case (.ignoredWithSuffix, _), (_, .ignoredWithSuffix):
            preconditionFailure("unreachable: values with a pending suffix are merged by `_StoredAttribute.append`")
        }
    }
}

extension _StoredAttribute {
    @usableFromInline
    struct Styles: Equatable, Sendable {
        @usableFromInline
        struct Entry: Equatable, Sendable {
            @usableFromInline
            let key: String
            @usableFromInline
            let value: String

            @usableFromInline
            init(key: String, value: String) {
                self.key = key
                self.value = value
            }

            @usableFromInline
            static func == (lhs: Entry, rhs: Entry) -> Bool {
                lhs.value.utf8Equals(rhs.value) && lhs.key.utf8Equals(rhs.key)
            }
        }

        @usableFromInline
        var styles: [Entry]

        @inlinable
        init(_ elements: some Sequence<(key: String, value: String)>) {
            self.styles = elements.map { Entry(key: $0.0, value: $0.1) }
        }

        @usableFromInline
        init(plainValue: String) {
            self.styles = [Entry(key: "", value: plainValue)]
        }

        mutating func append(plainValue: String) {
            styles.append(Entry(key: "", value: plainValue))
        }

        mutating func append(contentsOf other: consuming Styles) {
            let originalCount = styles.count
            for entry in other.styles {
                if entry.key.isEmpty {
                    styles.append(entry)
                } else {
                    for i in 0..<originalCount {
                        if styles[i].key.utf8Equals(entry.key) {
                            styles.remove(at: i)
                            break
                        }
                    }
                    styles.append(entry)
                }
            }
        }

        consuming func flatten() -> String {
            var result = ""
            for (index, entry) in styles.enumerated() {
                if index > 0 {
                    result += ";"
                }
                if entry.key.isEmpty {
                    result += entry.value
                } else {
                    result += "\(entry.key):\(entry.value)"
                }
            }
            return result
        }
    }

    @usableFromInline
    struct Classes: Equatable, Sendable {
        @usableFromInline
        var classes: [String]

        @inlinable
        init(_ elements: [String]) {
            self.classes = elements
        }

        @inlinable
        init(_ elements: some Sequence<String>) {
            self.classes = Array(elements)
        }

        mutating func append(plainValue newClass: String) {
            classes.append(newClass)
        }

        mutating func append(contentsOf other: consuming Classes) {
            let originalCount = classes.count
            for newClass in other.classes {
                if !classes.prefix(originalCount).contains(where: { $0.utf8Equals(newClass) }) {
                    classes.append(newClass)
                }
            }
        }

        consuming func flatten() -> String {
            classes.joined(separator: " ")
        }

        @usableFromInline
        static func == (lhs: Classes, rhs: Classes) -> Bool {
            lhs.classes.elementsEqual(rhs.classes, by: String.utf8Equals)
        }
    }
}

extension String {
    /// Compares the UTF-8 bytes of two strings.
    ///
    /// Unlike `==`, this does not apply unicode normalization (which is not available in embedded Swift).
    @inline(__always)
    @usableFromInline
    func utf8Equals(_ other: borrowing String) -> Bool {
        guard utf8.count == other.utf8.count else { return false }
        return contiguousUTF8Equals(other) ?? utf8.elementsEqual(other.utf8)
    }

    /// Compares the UTF-8 bytes of two strings via their contiguous storage, which all native strings have.
    ///
    /// Returns `nil` if either string has no contiguous UTF-8 storage (eg: bridged strings).
    @inline(__always)
    private func contiguousUTF8Equals(_ other: borrowing String) -> Bool? {
        utf8.withContiguousStorageIfAvailable { lhs in
            other.utf8.withContiguousStorageIfAvailable { rhs in
                // NOTE: an indexed loop compiles to much tighter code than `elementsEqual` here
                for index in lhs.indices where lhs[index] != rhs[index] {
                    return false
                }
                return true
            }
        } ?? nil
    }

    fileprivate static func utf8Equals(_ lhs: borrowing String, _ rhs: borrowing String) -> Bool {
        lhs.utf8Equals(rhs)
    }
}
