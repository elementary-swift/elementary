import Elementary
import Testing

struct AttributeMergingTests {
    /// Attributes are merged as soon as they are added, so the same attributes can be merged in different groupings
    /// (eg: a component's modifiers are merged before they reach the element). The result must not depend on it.
    ///
    /// The one exception are repeated class names: depending on the grouping they may only be rendered once, which
    /// results in the same set of classes in the same order.
    @Test(arguments: ["data-x", "class", "style"])
    func testMergingDoesNotDependOnGrouping(name: String) {
        let candidates = Self.candidates.filter { $0.name == name }
        var chainCount = 0

        for first in candidates {
            for second in candidates {
                for third in candidates {
                    let chain = [first, second, third]
                    let flat = render(p(attributes: chain) {})

                    #expect(render(p(attributes: [first]) {}.attributes(second).attributes(third)) == flat, "modifiers: \(chain)")
                    #expect(
                        withoutRepeatedClasses(render(Component(first).attributes(second).attributes(third)))
                            == withoutRepeatedClasses(flat),
                        "component: \(chain)"
                    )
                    #expect(withoutRepeatedClasses(mergedOutsideIn(chain)) == withoutRepeatedClasses(flat), "outside in: \(chain)")
                    chainCount += 1
                }
            }
        }

        #expect(chainCount == candidates.count * candidates.count * candidates.count)
    }

    @Test func testSpanContainsMergedAttributesInOrder() {
        var storage = _AttributeStorage([HTMLAttribute<HTMLTag.p>.id("1"), .class("a"), .hidden])
        storage.append(_AttributeStorage([HTMLAttribute<HTMLTag.p>.class("b"), .id("2"), .style("x")]))

        let attributes = storage._withSpan { span in
            span.indices.map { "\(span[$0].name)=\(span[$0].value ?? "")" }
        }
        #expect(attributes == ["id=2", "class=a b", "hidden=", "style=x"])
    }

    @available(*, deprecated, message: "tests the deprecated `flattened()`")
    @Test func testFlattenedIteratesMergedAttributes() {
        var storage = _AttributeStorage([HTMLAttribute<HTMLTag.p>.id("1"), .class("a"), .hidden])
        storage.append(_AttributeStorage([HTMLAttribute<HTMLTag.p>.class("b"), .id("2"), .style("x")]))

        let attributes = storage.flattened().map { "\($0.name)=\($0.value ?? "")" }
        #expect(attributes == ["id=2", "class=a b", "hidden=", "style=x"])
    }

    @Test func testSpanOfSingleAndNoAttributes() {
        #expect(_AttributeStorage()._withSpan { $0.count } == 0)
        #expect(_AttributeStorage(HTMLAttribute<HTMLTag.p>.id("1"))._withSpan { $0[0].value } == "1")
    }

    @Test func testIgnoredAttributeKeepsPendingAppendsAcrossGroupings() {
        let element = Component(.data("x", value: "base"))
            .attributes(.data("x", value: "ignored").mergedBy(.ignoring))
            .attributes(.data("x", value: "appended").mergedBy(.appending(separatedBy: "-")))

        #expect(render(element) == #" data-x="base-appended""#)
    }

    private static let candidates: [HTMLAttribute<HTMLTag.p>] = {
        let actions: [MarkupAttributeMergeAction] = [.replacing, .ignoring, .appending(separatedBy: " "), .appending(separatedBy: "-")]
        let data = actions.flatMap { action in
            [HTMLAttribute<HTMLTag.p>(name: "data-x", value: "v", mergedBy: action), .init(name: "data-x", value: nil, mergedBy: action)]
        }

        let classes: [HTMLAttribute<HTMLTag.p>] = [
            .class("a"), .class(["b", "c"]), .class("d").mergedBy(.replacing), .class("e").mergedBy(.ignoring),
        ]
        let styles: [HTMLAttribute<HTMLTag.p>] = [
            .style("color: red"), .style(["margin": "0", "color": "blue"]), .style(["margin": "1px"]),
            .style("top: 0").mergedBy(.replacing), .style("left: 0").mergedBy(.ignoring),
        ]

        return data + classes + styles
    }()
}

private struct Component: HTML {
    typealias Tag = HTMLTag.p

    let attribute: HTMLAttribute<HTMLTag.p>

    init(_ attribute: HTMLAttribute<HTMLTag.p>) {
        self.attribute = attribute
    }

    var body: some HTML {
        p(attribute) {}
    }
}

/// Renders only the attributes of a `<p></p>` element.
private func render(_ element: some HTML) -> String {
    String(element.render().dropFirst(2).dropLast(5))
}

/// Removes repeated names from a rendered `class` attribute, keeping the first occurrence of each.
private func withoutRepeatedClasses(_ rendered: String) -> String {
    guard rendered.hasPrefix(#" class=""#), rendered.hasSuffix(#"""#) else { return rendered }

    var seen: [Substring] = []
    for name in rendered.dropFirst(8).dropLast().split(separator: " ") where !seen.contains(name) {
        seen.append(name)
    }
    return #" class="\#(seen.joined(separator: " "))""#
}

/// Merges the attributes like ElementaryUI does with modifiers: each one is merged with the ones applied after it,
/// before being merged into the element.
private func mergedOutsideIn(_ attributes: [HTMLAttribute<HTMLTag.p>]) -> String {
    var outer = _AttributeStorage(attributes[attributes.count - 1])
    for attribute in attributes.dropFirst().dropLast().reversed() {
        var inner = _AttributeStorage(attribute)
        inner.append(outer)
        outer = inner
    }

    var storage = _AttributeStorage(attributes[0])
    storage.append(outer)

    return storage._withSpan { span in
        span.indices.map { index in
            span[index].value.map { #" \#(span[index].name)="\#($0)""# } ?? " \(span[index].name)"
        }.joined()
    }
}
