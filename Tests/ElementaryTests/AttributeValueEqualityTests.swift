import Testing

@testable import Elementary

struct AttributeValueEqualityTests {

    // MARK: - utf8Equals

    @Test func testUTF8EqualsIdenticalLiterals() {
        let short = "card"
        let long = "a long string literal that is not stored inline"
        #expect(short.utf8Equals("card"))
        #expect(long.utf8Equals("a long string literal that is not stored inline"))
        #expect(long.utf8Equals(long))
    }

    @Test func testUTF8EqualsSeparatelyBuiltLongStrings() {
        let count = 3
        let lhs = "item-\(count)-\(String(repeating: "x", count: 20))"
        let rhs = "item-\(count)-\(String(repeating: "x", count: 20))"
        #expect(lhs.utf8.count > 15)
        #expect(lhs.utf8Equals(rhs))
        #expect(String(repeating: "ab", count: 16).utf8Equals(String(repeating: "ab", count: 16)))
    }

    @Test func testUTF8EqualsDifferentStringsOfEqualLength() {
        #expect(!"card".utf8Equals("cart"))
        #expect(!String(repeating: "x", count: 32).utf8Equals(String(repeating: "x", count: 31) + "y"))
    }

    @Test func testUTF8EqualsDifferentLengths() {
        #expect(!"card".utf8Equals("cards"))
        #expect(!String(repeating: "x", count: 32).utf8Equals(String(repeating: "x", count: 33)))
        #expect(!"".utf8Equals("x"))
    }

    @Test func testUTF8EqualsEmptyStrings() {
        #expect("".utf8Equals(""))
        #expect("".utf8Equals(String()))
        #expect(String(repeating: "x", count: 0).utf8Equals(""))
    }

    // MARK: - _hasKnownEqualValue

    @Test func testPlainValues() {
        #expect(stored(.id("a"))._hasKnownEqualValue(to: stored(.id("a"))))
        #expect(stored(.id("a"))._hasKnownEqualValue(to: stored(.title("a"))))
        #expect(!stored(.id("a"))._hasKnownEqualValue(to: stored(.id("b"))))
        #expect(!stored(.id("a"))._hasKnownEqualValue(to: stored(.id("ab"))))
    }

    @Test func testClasses() {
        #expect(stored(.class(["foo", "bar"]))._hasKnownEqualValue(to: stored(.class(["foo", "bar"]))))
        #expect(!stored(.class(["foo", "bar"]))._hasKnownEqualValue(to: stored(.class(["foo", "baz"]))))
        #expect(!stored(.class(["foo", "bar"]))._hasKnownEqualValue(to: stored(.class(["bar", "foo"]))))
        #expect(!stored(.class(["foo"]))._hasKnownEqualValue(to: stored(.class(["foo", "bar"]))))
    }

    @Test func testStyles() {
        #expect(stored(.style(["color": "red", "margin": "0"]))._hasKnownEqualValue(to: stored(.style(["color": "red", "margin": "0"]))))
        #expect(stored(.style("color: red"))._hasKnownEqualValue(to: stored(.style("color: red"))))
        #expect(!stored(.style(["color": "red"]))._hasKnownEqualValue(to: stored(.style(["color": "blue"]))))
        #expect(!stored(.style(["color": "red"]))._hasKnownEqualValue(to: stored(.style(["background": "red"]))))
        #expect(!stored(.style("color: red"))._hasKnownEqualValue(to: stored(.style("color: blue"))))
    }

    @Test func testEmptyVsPlain() {
        #expect(stored(.hidden)._hasKnownEqualValue(to: stored(.hidden)))
        #expect(!stored(.hidden)._hasKnownEqualValue(to: stored(.id(""))))
        #expect(!stored(.id(""))._hasKnownEqualValue(to: stored(.hidden)))
    }

    @Test func testIgnoresNameAndMergeMode() {
        let replacing = stored(.custom(name: "data-x", value: "a"))
        let ignoring = stored(HTMLAttribute<HTMLTag.div>.custom(name: "data-y", value: "a").mergedBy(.ignoring))
        #expect(replacing._hasKnownEqualValue(to: ignoring))
    }

    @Test func testNeverTrueForDifferentRenderings() {
        let candidates = Self.candidates
        var matches = 0
        for lhs in candidates {
            for rhs in candidates where lhs._hasKnownEqualValue(to: rhs) {
                #expect(lhs.value == rhs.value, "\(lhs.name)=\(lhs.value ?? "nil") vs \(rhs.name)=\(rhs.value ?? "nil")")
                matches += 1
            }
        }
        #expect(matches >= candidates.count)
    }

    static let candidates: [_StoredAttribute] = {
        let attributes: [[HTMLAttribute<HTMLTag.div>]] = [
            [.hidden],
            [.id("")],
            [.id("a")],
            [.id("a b")],
            [.class("a")],
            [.class("a b")],
            [.class(["a", "b"])],
            [.class(["b", "a"])],
            [.class("a"), .class("b")],
            [.class(["a"]), .class("b")],
            [.style("color:red")],
            [.style(["color": "red"])],
            [.style(["color": "red", "margin": "0"])],
            [.style(["color": "red"]), .style(["margin": "0"])],
            [.style(["color": "red"]), .style(["color": "blue"])],
            [
                .custom(name: "data-x", value: "a").mergedBy(.ignoring),
                .custom(name: "data-x", value: "b").mergedBy(.appending(separatedBy: " ")),
            ],
            [
                .custom(name: "data-x", value: "a").mergedBy(.ignoring),
                .custom(name: "data-x", value: "c").mergedBy(.appending(separatedBy: " ")),
            ],
            [.custom(name: "data-x", value: "a b").mergedBy(.ignoring)],
        ]
        // build everything twice, so equal values are compared across separately built storage
        return (attributes + attributes).flatMap { Array(_AttributeStorage($0).flattened()) }
    }()
}

private func stored(_ attribute: HTMLAttribute<HTMLTag.div>) -> _StoredAttribute {
    attribute.htmlAttribute
}
