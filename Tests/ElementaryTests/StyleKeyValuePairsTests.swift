import Testing

@testable import Elementary

struct StyleKeyValuePairsTests {

    // MARK: - Structured styles

    @Test func testStructuredStylesPreserveOrderAndAllowEmptyValue() {
        assertPairs(
            makeStructured(["color": "red", "font-size": "16px", "margin": ""]),
            [
                ("color", "red"),
                ("font-size", "16px"),
                ("margin", ""),
            ]
        )
    }

    @Test func testStructuredEmptyStylesYieldsEmptySequence() {
        let attr = _StoredAttribute(_StoredAttribute.Styles([:] as KeyValuePairs<String, String>))
        let pairs = collectPairs(from: attr)
        #expect(pairs != nil)
        #expect(pairs?.count == 0)
    }

    // MARK: - Plain style parsing (.plain style attribute path)

    @Test func testPlainStyleParsingCoreCases() {
        let cases: [(String, [(String, String)])] = [
            ("color:red", [("color", "red")]),
            ("color:red;font-size:16px", [("color", "red"), ("font-size", "16px")]),
            ("color : red ; font-size : 16px", [("color", "red"), ("font-size", "16px")]),
            ("background:url(http://example.com)", [("background", "url(http://example.com)")]),
            ("x:1", [("x", "1")]),
            ("color:   ", [("color", "")]),
            ("color:;font-size:16px", [("color", ""), ("font-size", "16px")]),
            ("color:\tred", [("color", "red")]),
            ("color:red\n", [("color", "red")]),
            ("color:red;\nfont-size:16px", [("color", "red"), ("font-size", "16px")]),
        ]
        for (input, expected) in cases {
            assertPlainPairs(input, expected)
        }
    }

    @Test func testPlainStyleParsingToleratesEmptySemicolonParts() {
        let cases: [(String, [(String, String)])] = [
            ("color:red;", [("color", "red")]),
            (";color:red", [("color", "red")]),
            ("color:red;;font-size:16px", [("color", "red"), ("font-size", "16px")]),
            ("color:red;;;font-size:16px", [("color", "red"), ("font-size", "16px")]),
            (";;;", []),
        ]
        for (input, expected) in cases {
            assertPlainPairs(input, expected)
        }
    }

    @Test func testPlainStyleParsingSkipsInvalidDeclarations() {
        let cases: [(String, [(String, String)])] = [
            ("", []),
            ("   ", []),
            ("not-a-declaration", []),
            (":", []),
            (":red", []),
            ("   :red", []),
            ("color:red;invalid;font-size:16px", [("color", "red"), ("font-size", "16px")]),
        ]
        for (input, expected) in cases {
            assertPlainPairs(input, expected)
        }
    }

    // MARK: - Merge behavior

    @Test func testMergedPlainStylesKeepAllDeclarationsInOrder() {
        var styles = _StoredAttribute.Styles(plainValue: "color:red;display:flex")
        styles.append(plainValue: "font-size:16px;margin:0")
        let attr = _StoredAttribute(styles)
        assertPairs(
            attr,
            [
                ("color", "red"),
                ("display", "flex"),
                ("font-size", "16px"),
                ("margin", "0"),
            ]
        )
    }

    @Test func testMixedStructuredAndPlainMergeKeepsExpectedOrder() {
        var attr = makeStructured(["color": "red", "display": "flex"])
        attr.mergeWith(makeStylesFromPlain("font-size:16px; margin: 0"))
        attr.mergeWith(makeStructured(["padding": "8px"]))
        assertPairs(
            attr,
            [
                ("color", "red"),
                ("display", "flex"),
                ("font-size", "16px"),
                ("margin", "0"),
                ("padding", "8px"),
            ]
        )
    }

    @Test func testPlainEntriesAreNotDeduplicatedAgainstStructuredKeys() {
        var attr = makeStylesFromPlain("color:red")
        attr.mergeWith(makeStructured(["color": "blue"]))
        let pairs = collectPairs(from: attr)!
        let colorPairs = pairs.filter { $0.key == "color" }
        #expect(colorPairs.count == 2)
        #expect(colorPairs[0].value == "red")
        #expect(colorPairs[1].value == "blue")
    }

    // MARK: - Non-style / empty behavior

    @Test func testStyleNameInPlainAttributeIsParsed() {
        let attr = _StoredAttribute(name: "style", value: "color:red;font-size:16px", mergeMode: .replaceValue)
        assertPairs(attr, [("color", "red"), ("font-size", "16px")])
    }

    @Test func testNonStyleOrEmptyAttributesReturnNil() {
        let classPlain = _StoredAttribute(name: "class", value: "foo bar", mergeMode: .replaceValue)
        let classAttr = _StoredAttribute(name: "class", value: "foo", mergeMode: .replaceValue)
        let emptyStyle = _StoredAttribute(name: "style", value: nil, mergeMode: .replaceValue)
        #expect(classPlain._styleKeyValuePairs == nil)
        #expect(classAttr._styleKeyValuePairs == nil)
        #expect(emptyStyle._styleKeyValuePairs == nil)
    }

    // MARK: - Helpers

    private func collectPairs(from attr: _StoredAttribute) -> [(key: String, value: String)]? {
        guard let pairs = attr._styleKeyValuePairs else { return nil }
        return pairs.map { (k, v) in (key: String(Substring(k)), value: String(Substring(v))) }
    }

    private func assertPairs(
        _ attr: _StoredAttribute,
        _ expected: [(String, String)],
        sourceLocation: SourceLocation = #_sourceLocation
    ) {
        guard let pairs = collectPairs(from: attr) else {
            Issue.record("styleKeyValuePairs returned nil", sourceLocation: sourceLocation)
            return
        }
        #expect(pairs.count == expected.count, "pair count mismatch", sourceLocation: sourceLocation)
        for (i, (expectedKey, expectedValue)) in expected.enumerated() {
            guard i < pairs.count else { break }
            #expect(pairs[i].key == expectedKey, "key mismatch at index \(i)", sourceLocation: sourceLocation)
            #expect(pairs[i].value == expectedValue, "value mismatch at index \(i)", sourceLocation: sourceLocation)
        }
    }

    private func makeStructured(_ entries: KeyValuePairs<String, String>) -> _StoredAttribute {
        _StoredAttribute(.init(entries))
    }

    /// Creates a `.plain` style attribute (generic name/value init) — for testing `.plain` path support.
    private func makePlainAttr(_ value: String) -> _StoredAttribute {
        _StoredAttribute(name: "style", value: value, mergeMode: .replaceValue)
    }

    /// Creates a `.styles` attribute from a plain CSS string — matches real API behavior and supports merge.
    private func makeStylesFromPlain(_ value: String) -> _StoredAttribute {
        _StoredAttribute(_StoredAttribute.Styles(plainValue: value))
    }

    private func assertPlainPairs(
        _ value: String,
        _ expected: [(String, String)],
        sourceLocation: SourceLocation = #_sourceLocation
    ) {
        assertPairs(makePlainAttr(value), expected, sourceLocation: sourceLocation)
    }
}
