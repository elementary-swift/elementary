import XCTest

@testable import Elementary

final class StyleKeyValuePairsTests: XCTestCase {

    // MARK: - Structured styles

    func testStructuredStylesPreserveOrderAndAllowEmptyValue() {
        assertPairs(
            makeStructured(["color": "red", "font-size": "16px", "margin": ""]),
            [
                ("color", "red"),
                ("font-size", "16px"),
                ("margin", ""),
            ]
        )
    }

    func testStructuredEmptyStylesYieldsEmptySequence() {
        let attr = _StoredAttribute(_StoredAttribute.Styles([:] as KeyValuePairs<String, String>))
        let pairs = collectPairs(from: attr)
        XCTAssertNotNil(pairs)
        XCTAssertEqual(pairs?.count, 0)
    }

    // MARK: - Plain style parsing (.plain style attribute path)

    func testPlainStyleParsingCoreCases() {
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

    func testPlainStyleParsingToleratesEmptySemicolonParts() {
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

    func testPlainStyleParsingSkipsInvalidDeclarations() {
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

    func testMergedPlainStylesKeepAllDeclarationsInOrder() {
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

    func testMixedStructuredAndPlainMergeKeepsExpectedOrder() {
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

    func testPlainEntriesAreNotDeduplicatedAgainstStructuredKeys() {
        var attr = makeStylesFromPlain("color:red")
        attr.mergeWith(makeStructured(["color": "blue"]))
        let pairs = collectPairs(from: attr)!
        let colorPairs = pairs.filter { $0.key == "color" }
        XCTAssertEqual(colorPairs.count, 2)
        XCTAssertEqual(colorPairs[0].value, "red")
        XCTAssertEqual(colorPairs[1].value, "blue")
    }

    // MARK: - Non-style / empty behavior

    func testStyleNameInPlainAttributeIsParsed() {
        let attr = _StoredAttribute(name: "style", value: "color:red;font-size:16px", mergeMode: .replaceValue)
        assertPairs(attr, [("color", "red"), ("font-size", "16px")])
    }

    func testNonStyleOrEmptyAttributesReturnNil() {
        let classPlain = _StoredAttribute(name: "class", value: "foo bar", mergeMode: .replaceValue)
        let classAttr = _StoredAttribute(name: "class", value: "foo", mergeMode: .replaceValue)
        let emptyStyle = _StoredAttribute(name: "style", value: nil, mergeMode: .replaceValue)
        XCTAssertNil(classPlain.styleKeyValuePairs)
        XCTAssertNil(classAttr.styleKeyValuePairs)
        XCTAssertNil(emptyStyle.styleKeyValuePairs)
    }

    // MARK: - Helpers

    private func collectPairs(from attr: _StoredAttribute) -> [(key: String, value: String)]? {
        guard let pairs = attr.styleKeyValuePairs else { return nil }
        return pairs.map { (String($0.key), String($0.value)) }
    }

    private func assertPairs(
        _ attr: _StoredAttribute,
        _ expected: [(String, String)],
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        guard let pairs = collectPairs(from: attr) else {
            XCTFail("styleKeyValuePairs returned nil", file: file, line: line)
            return
        }
        XCTAssertEqual(pairs.count, expected.count, "pair count mismatch", file: file, line: line)
        for (i, (expectedKey, expectedValue)) in expected.enumerated() {
            guard i < pairs.count else { break }
            XCTAssertEqual(pairs[i].key, expectedKey, "key mismatch at index \(i)", file: file, line: line)
            XCTAssertEqual(pairs[i].value, expectedValue, "value mismatch at index \(i)", file: file, line: line)
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
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        assertPairs(makePlainAttr(value), expected, file: file, line: line)
    }
}
