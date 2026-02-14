extension _StoredAttribute {

    /// Returns style key-value pairs if this is a style attribute, or `nil` otherwise.
    @inlinable
    public var styleKeyValuePairs: StyleKeyValuePairs? {
        switch _value {
        case .styles(let styles):
            return StyleKeyValuePairs(styles)
        case .plain(let value) where name.utf8Equals("style"):
            return StyleKeyValuePairs(plainValue: value)
        default:
            return nil
        }
    }

    /// Lazily yields CSS style key-value pairs from structured and/or plain-text style entries.
    public struct StyleKeyValuePairs: Sequence, Sendable {
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
            var remaining: Substring

            @usableFromInline
            init(_ entries: [Styles.Entry], plainValue: String?) {
                self.entries = entries
                self.entryIndex = 0
                self.remaining = plainValue.map { Substring($0) } ?? Substring()
            }

            @inlinable
            public mutating func next() -> (key: Substring, value: Substring)? {
                while true {
                    if let pair = _nextStylePair(from: &remaining) { return pair }

                    guard entryIndex < entries.count else { return nil }
                    let entry = entries[entryIndex]
                    entryIndex &+= 1

                    if entry.key.utf8.isEmpty {
                        remaining = Substring(entry.value)
                    } else {
                        return (key: Substring(entry.key), value: Substring(entry.value))
                    }
                }
            }
        }
    }
}

/// Parses the next semicolon-delimited `key:value` pair from a CSS declaration substring.
@inline(__always)
@usableFromInline
func _nextStylePair(from remaining: inout Substring) -> (key: Substring, value: Substring)? {
    while !remaining.utf8.isEmpty {
        let current = remaining
        let utf8 = current.utf8
        let utf8End = utf8.endIndex

        var cursor = utf8.startIndex
        var colon: String.Index?

        while cursor < utf8End {
            let byte = utf8[cursor]

            // :
            if byte == 0x3A, colon == nil {
                colon = cursor
            }

            // ;
            if byte == 0x3B {
                break
            }

            utf8.formIndex(after: &cursor)
        }

        let partEnd = cursor
        if cursor < utf8End {
            remaining = current[utf8.index(after: cursor)...]
        } else {
            remaining = Substring()
        }

        guard let colon else { continue }

        let key = current[..<colon]._trimmedSpaces
        guard !key.utf8.isEmpty else { continue }
        let valueStart = utf8.index(after: colon)
        let value = current[valueStart..<partEnd]._trimmedSpaces

        return (key: key, value: value)
    }
    return nil
}

extension Substring {
    /// Trims leading and trailing CSS ASCII whitespace:
    /// space (0x20), tab (0x09), LF (0x0A), CR (0x0D), FF (0x0C).
    @inline(__always)
    @usableFromInline
    var _trimmedSpaces: Substring {
        var lo = utf8.startIndex
        var hi = utf8.endIndex
        while lo < hi, utf8[lo]._isCSSASCIIWhitespace { utf8.formIndex(after: &lo) }
        while hi > lo, utf8[utf8.index(before: hi)]._isCSSASCIIWhitespace { utf8.formIndex(before: &hi) }
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
