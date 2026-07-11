import Elementary
import Testing

struct ContentBuilderTests {
    @Test func testContentBuilderBuildsHTML() async throws {
        try await HTMLAssertEqual(
            BuiltWithContentBuilder(),
            "<p>Hello from ContentBuilder</p>"
        )
    }

    @Test func testStructuralContentCanStoreNonHTMLValues() {
        let group = Group {
            1
        }
        #expect(group.content == 1)

        let conditional = _ConditionalContent<Int, String>(.falseContent("fallback"))
        switch conditional.value {
        case .trueContent:
            Issue.record("Expected falseContent value")
        case let .falseContent(value):
            #expect(value == "fallback")
        }

        let array = _ArrayContent([1, 2, 3])
        #expect(array.value == [1, 2, 3])

        let tuple = _TupleContent2(v0: 1, v1: "two")
        #expect(tuple.v0 == 1)
        #expect(tuple.v1 == "two")

        let forEach = ForEach([1, 2, 3]) { number in
            number * 2
        }
        #expect(forEach._data == [1, 2, 3])
        #expect(forEach._contentBuilder(2) == 4)
    }
}

private struct BuiltWithContentBuilder: HTML {
    @ContentBuilder var body: some HTML {
        p { "Hello from ContentBuilder" }
    }
}
