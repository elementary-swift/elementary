import Elementary
import Testing

struct TagRenderingTests {
    @Test func testRendersEmptyTag() async throws {
        try await HTMLAssertEqual(
            p {},
            "<p></p>"
        )
    }

    @Test func testRendersNestedTags() async throws {
        try await HTMLAssertEqual(
            div { p {} },
            "<div><p></p></div>"
        )
    }

    @Test func testRendersSelfClosingTag() async throws {
        try await HTMLAssertEqual(
            br(),
            "<br>"
        )
    }

    @Test func testRendersTuples() async throws {
        try await HTMLAssertEqual(
            div {
                h1 {}
                p {}
            },
            "<div><h1></h1><p></p></div>"
        )
    }

    @Test func testRendersGroup() async throws {
        try await HTMLAssertEqual(
            div {
                Group {
                    h1 {}
                    Group {
                        if true {
                            p {}
                            p {}
                        }
                    }
                    h1 {}
                }
            },
            "<div><h1></h1><p></p><p></p><h1></h1></div>"
        )
    }

    @Test func testRendersOptionals() async throws {
        try await HTMLAssertEqual(
            div {
                if true {
                    p {}
                }
            },
            "<div><p></p></div>"
        )

        try await HTMLAssertEqual(
            div {
                if false {
                    p {}
                }
            },
            "<div></div>"
        )
    }

    @Test func testRendersConditionals() async throws {
        try await HTMLAssertEqual(
            div {
                if true {
                    p {}
                } else {
                    span {}
                }
            },
            "<div><p></p></div>"
        )

        try await HTMLAssertEqual(
            div {
                if false {
                    p {}
                } else {
                    span {}
                }
            },
            "<div><span></span></div>"
        )
    }

    @Test func testRendersLists() async throws {
        try await HTMLAssertEqual(
            div {
                for _ in 0..<3 {
                    p {}
                }
            },
            "<div><p></p><p></p><p></p></div>"
        )
    }
}
