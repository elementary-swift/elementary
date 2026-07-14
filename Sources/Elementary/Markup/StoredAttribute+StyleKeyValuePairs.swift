extension _StoredAttribute {

    /// Returns style key-value pairs if this is a style attribute, or `nil` otherwise.
    @inlinable
    public var _styleKeyValuePairs: _StyleKeyValuePairs? {
        switch _value {
        case .styles(let styles):
            return _StyleKeyValuePairs(styles)
        case .plain(let value) where name.utf8Equals("style"):
            return _StyleKeyValuePairs(plainValue: value)
        default:
            return nil
        }
    }

    /// Lazily yields CSS style key-value pairs from structured and/or plain-text style entries.
    public struct _StyleKeyValuePairs: Sequence, Sendable {
        @usableFromInline
        var entries: [Styles.Entry]
        @usableFromInline
        var plainValue: String?

        @usableFromInline
        init(_ styles: Styles) {
            self.entries = styles.styles
            self.plainValue = nil
        }

        @usableFromInline
        init(plainValue: String) {
            self.entries = []
            self.plainValue = plainValue
        }

        @inlinable
        public consuming func makeIterator() -> Iterator {
            Iterator(entries, plainValue: plainValue)
        }

        public struct Iterator: IteratorProtocol {
            @usableFromInline
            var entries: [Styles.Entry]
            @usableFromInline
            var entryIndex: Int
            @usableFromInline
            var remaining: Substring.UTF8View

            @usableFromInline
            init(_ entries: [Styles.Entry], plainValue: String?) {
                self.entries = entries
                self.entryIndex = 0
                self.remaining = plainValue.map { Substring($0).utf8 } ?? Substring().utf8
            }

            @inlinable
            public mutating func next() -> (key: Substring.UTF8View, value: Substring.UTF8View)? {
                while true {
                    if let pair = _nextStylePair(from: &remaining) { return pair }

                    guard entryIndex < entries.count else { return nil }
                    let entry = entries[entryIndex]
                    entryIndex &+= 1

                    if entry.key.utf8.isEmpty {
                        remaining = Substring(entry.value).utf8
                    } else {
                        return (key: Substring(entry.key).utf8, value: Substring(entry.value).utf8)
                    }
                }
            }
        }
    }
}

/// Parses the next semicolon-delimited `key:value` pair from a CSS declaration UTF-8 view.
@inline(__always)
@usableFromInline
func _nextStylePair(from remaining: inout Substring.UTF8View) -> (key: Substring.UTF8View, value: Substring.UTF8View)? {
    while !remaining.isEmpty {
        let current = remaining
        let utf8End = current.endIndex

        var cursor = current.startIndex
        var colon: Substring.UTF8View.Index?

        while cursor < utf8End {
            let byte = current[cursor]

            // :
            if byte == 0x3A, colon == nil {
                colon = cursor
            }

            // ;
            if byte == 0x3B {
                break
            }

            current.formIndex(after: &cursor)
        }

        let partEnd = cursor
        if cursor < utf8End {
            remaining = current[current.index(after: cursor)...]
        } else {
            remaining = Substring().utf8
        }

        guard let colon else { continue }

        let key = current[current.startIndex..<colon]._trimmedSpaces
        guard !key.isEmpty else { continue }
        let valueStart = current.index(after: colon)
        let value = current[valueStart..<partEnd]._trimmedSpaces

        return (key: key, value: value)
    }
    return nil
}

extension Substring.UTF8View {
    /// Trims leading and trailing CSS ASCII whitespace:
    /// space (0x20), tab (0x09), LF (0x0A), CR (0x0D), FF (0x0C).
    @inline(__always)
    @usableFromInline
    var _trimmedSpaces: Substring.UTF8View {
        var lo = startIndex
        var hi = endIndex
        while lo < hi, self[lo]._isCSSASCIIWhitespace { formIndex(after: &lo) }
        while hi > lo, self[index(before: hi)]._isCSSASCIIWhitespace { formIndex(before: &hi) }
        return self[lo..<hi]
    }
}

extension UInt8 {
    @inline(__always)
    @usableFromInline
    var _isCSSASCIIWhitespace: Bool {
        self == 0x20 || self == 0x09 || self == 0x0A || self == 0x0D || self == 0x0C
    }
}
