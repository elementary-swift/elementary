import Elementary
import Testing

struct TextRenderingTests {
    @Test func testRendersText() async throws {
        try await HTMLAssertEqual(
            h1 { "Hello, World!" },
            "<h1>Hello, World!</h1>"
        )
    }

    @Test func testEscapesText() async throws {
        try await HTMLAssertEqual(
            h1 { #""Hello" 'World' & <FooBar>"# },
            #"<h1>"Hello" 'World' &amp; &lt;FooBar&gt;</h1>"#
        )
    }

    @Test func testDoesNotEscapeRawText() async throws {
        try await HTMLAssertEqual(
            h1 { HTMLRaw(#""Hello" 'World' & <FooBar>"#) },
            #"<h1>"Hello" 'World' & <FooBar></h1>"#
        )
    }

    @Test func testRendersListsOfText() async throws {
        try await HTMLAssertEqual(
            div {
                "Hello, "
                "World!"
            },
            "<div>Hello, World!</div>"
        )
    }

    @Test func testRendersTextWithInlineTags() async throws {
        try await HTMLAssertEqual(
            div {
                "He"
                b { "llo" }
                br()
                span { "World!" }
            },
            "<div>He<b>llo</b><br><span>World!</span></div>"
        )
    }

    @Test func testRendersComment() async throws {
        try await HTMLAssertEqual(
            div {
                HTMLComment("Hello !--> World")
            },
            "<div><!--Hello !--&gt; World--></div>"
        )
    }

    @Test func testRendersRaw() async throws {
        try await HTMLAssertEqual(
            div {
                HTMLRaw(#"<my-tag>"&amp;"</my-tag>"#)
            },
            #"<div><my-tag>"&amp;"</my-tag></div>"#
        )
    }
}

class Bar {
    var foo: String = ""
}

class JO: HTML {
    var bar: Bar = .init()

    var body: some HTML {
        "Hello, World!"
    }
}
