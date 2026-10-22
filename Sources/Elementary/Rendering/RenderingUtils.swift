#if !hasFeature(Embedded)
extension _RenderingContext {
    @inline(__always)
    @usableFromInline
    func assertNoAttributes(_ type: (some _Renderable).Type) {
        #if hasFeature(Embedded)
        assert(attributes.isEmpty, "Attributes are not supported")
        #else
        assert(attributes.isEmpty, "Attributes are not supported on \(type)")
        #endif
    }

    @inline(__always)
    @usableFromInline
    func assertionFailureNoAsyncContext(_ type: (some _Renderable).Type) {
        #if hasFeature(Embedded)
        assertionFailure("Cannot render async content in a synchronous context, please use .render(into:) or .renderAsync() instead.")
        #else
        let message = "Cannot render \(type) in a synchronous context, please use .render(into:) or .renderAsync() instead."
        print("Elementary rendering error: \(message)")

        assertionFailure(message)
        #endif
    }
}

// I do not know why this function does not work in embedded, but currently it crashes the compiler

extension [UInt8] {
    @inline(__always)
    mutating func appendToken(_ token: consuming _HTMLRenderToken) {
        // avoid strings and append each component directly
        switch token {
        case let .startTag(tagName, attributes: attributes, isUnpaired: _, type: _):
            append(60)  // <
            appendString(tagName)
            if !attributes.isEmpty {
                appendAttributes(attributes)
            }
            append(62)  // >
        case let .selfClosingTag(tagName, attributes: attributes):
            append(60)  // <
            appendString(tagName)
            if !attributes.isEmpty {
                appendAttributes(attributes)
            }
            append(32)  // space
            append(47)  // /
            append(62)  // >
        case let .endTag(tagName, _):
            append(60)  // <
            append(47)  // /
            appendString(tagName)
            append(62)  // >
        case let .text(text):
            appendEscapedText(text)
        case let .raw(raw):
            appendString(raw)
        case let .comment(comment):
            appendString("<!--")
            appendEscapedText(comment)
            appendString("-->")
        }
    }

    @inline(never)
    mutating func appendAttributes(_ attributes: borrowing _MergedAttributes) {
        attributes.forEachMerged { attribute in
            append(32)  // space
            appendString(attribute.name)
            switch attribute._value {
            case .empty:
                break
            case let .plain(value):
                append(61)  // =
                append(34)  // "
                appendEscapedAttributeValue(value)
                append(34)  // "
            case let .classes(classes):
                append(61)  // =
                append(34)  // "
                for (index, value) in classes.classes.enumerated() {
                    if index > 0 { append(32) }  // space
                    appendEscapedAttributeValue(value)
                }
                append(34)  // "
            case let .styles(styles):
                append(61)  // =
                append(34)  // "
                for (index, entry) in styles.styles.enumerated() {
                    if index > 0 { append(59) }  // ;
                    if !entry.key.utf8.isEmpty {
                        appendEscapedAttributeValue(entry.key)
                        append(58)  // :
                    }
                    appendEscapedAttributeValue(entry.value)
                }
                append(34)  // "
            }
        }
    }

    @inline(__always)
    mutating func appendString(_ string: consuming String) {
        string.withUTF8 { utf8 in
            append(contentsOf: utf8)
        }
    }

    @inline(__always)
    mutating func appendEscapedAttributeValue(_ value: consuming String) {
        value.withUTF8 { utf8 in
            var start = utf8.startIndex

            for current in utf8.indices {
                switch utf8[current] {
                case 38:  // &
                    append(contentsOf: utf8[start..<current])
                    appendString("&amp;")
                    start = utf8.index(after: current)
                case 34:  // "
                    append(contentsOf: utf8[start..<current])
                    appendString("&quot;")
                    start = utf8.index(after: current)
                default:
                    ()
                }
            }

            if start < utf8.endIndex {
                append(contentsOf: utf8[start..<utf8.endIndex])
            }
        }
    }

    @inline(__always)
    mutating func appendEscapedText(_ value: consuming String) {
        value.withUTF8 { utf8 in
            var start = utf8.startIndex

            for current in utf8.indices {
                switch utf8[current] {
                case 38:  // &
                    append(contentsOf: utf8[start..<current])
                    appendString("&amp;")
                    start = utf8.index(after: current)
                case 60:  // <
                    append(contentsOf: utf8[start..<current])
                    appendString("&lt;")
                    start = utf8.index(after: current)
                case 62:  // >
                    append(contentsOf: utf8[start..<current])
                    appendString("&gt;")
                    start = utf8.index(after: current)
                default:
                    ()
                }
            }

            if start < utf8.endIndex {
                append(contentsOf: utf8[start..<utf8.endIndex])
            }
        }
    }
}
#endif
