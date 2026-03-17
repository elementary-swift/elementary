import Elementary
import Testing

struct ClassAndStyleRenderingTests {
    @Test func testRendersClasses() async throws {
        try await HTMLAssertEqual(
            p(.class(["foo", "bar"])) {},
            #"<p class="foo bar"></p>"#
        )
    }

    @Test func testMergesClassesKeepingSequence() async throws {
        try await HTMLAssertEqual(
            p(
                .class(["foo", "bar"]),
                .class(["foo", "baz"])
            ) {}
            .attributes(
                .class("do not touch"),
                .class(["baz", "end"])
            ),
            #"<p class="foo bar baz do not touch end"></p>"#
        )
    }

    @Test func testRendersStyles() async throws {
        try await HTMLAssertEqual(
            p(.style(["color": "red", "font-size": "16px"])) {},
            #"<p style="color:red;font-size:16px"></p>"#
        )
    }

    @Test func testRendersStylesFromDictionary() async throws {
        let styles = [
            "display": "flex"
        ]
        try await HTMLAssertEqual(
            p(.style(styles)) {},
            #"<p style="display:flex"></p>"#
        )
    }

    @Test func testMergesStylesKeepingSequence() async throws {
        try await HTMLAssertEqual(
            p(.style(["color": "red", "font-size": "16px"])) {}
                .attributes(
                    .style("do: not-touch"),
                    .style(["font-size": "24px", "flex": "auto"])
                ),
            #"<p style="color:red;do: not-touch;font-size:24px;flex:auto"></p>"#
        )
    }
}
