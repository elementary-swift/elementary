import Elementary
import Testing

struct AttributeRenderingTests {
    @Test func testRendersAnAttribute() async throws {
        try await HTMLAssertEqual(
            p(.id("foo")) {},
            #"<p id="foo"></p>"#
        )
    }

    @Test func testRendersAttributes() async throws {
        try await HTMLAssertEqual(
            p(.id("foo"), .class("foo"), .role("note"), .hidden) {},
            #"<p id="foo" class="foo" role="note" hidden></p>"#
        )
    }

    @Test func testEscapesAttributeValues() async throws {
        try await HTMLAssertEqual(
            p(.id("foo\""), .class("&foo<>")) {},
            #"<p id="foo&quot;" class="&amp;foo<>"></p>"#
        )
    }

    @Test func testRendersAppliedAttributes() async throws {
        try await HTMLAssertEqual(
            p {}.attributes(.id("foo"), .class("bar")),
            #"<p id="foo" class="bar"></p>"#
        )
    }

    @Test func testKeepsAttributeOrder() async throws {
        try await HTMLAssertEqual(
            p(.id("1")) { "yo" }.attributes(.class("2")).attributes(.lang("de-AT")),
            #"<p id="1" class="2" lang="de-AT">yo</p>"#
        )
    }

    @Test func testAppliesConditionalAttributes() async throws {
        try await HTMLAssertEqual(
            img(.id("1")).attributes(.class("2"), .id("no"), when: false).attributes(.style("2"), when: true),
            #"<img id="1" style="2">"#
        )
    }

    @Test func testMergesClassAndStyleByDefault() async throws {
        try await HTMLAssertEqual(
            p(.class("first")) {}.attributes(.class("second"), .style("style1")).attributes(.style("style2")),
            #"<p class="first second" style="style1;style2"></p>"#
        )
    }

    @Test func testOverridesByDefault() async throws {
        try await HTMLAssertEqual(
            br(.id("foo")).attributes(.hidden, .id("bar")).attributes(.id("baz")),
            #"<br id="baz" hidden>"#
        )
    }

    @Test func testRespectsCustomMergeMode() async throws {
        try await HTMLAssertEqual(
            br(.id("1"), .data("bar", value: "baz"))
                .attributes(.id("2").mergedBy(.appending(separatedBy: "-")))
                .attributes(.id("3").mergedBy(.ignoring))
                .attributes(.data("bar", value: "baq").mergedBy(.appending(separatedBy: ""))),
            #"<br id="1-2" data-bar="bazbaq">"#
        )
    }

    @Test func testRendersMouseEventAttribute() async throws {
        try await HTMLAssertEqual(
            p(.on(.click, "doIt()")) {},
            #"<p onclick="doIt()"></p>"#
        )
    }

    @Test func testRendersKeyboardEventAttribute() async throws {
        try await HTMLAssertEqual(
            p(.on(.keydown, "doIt()")) {},
            #"<p onkeydown="doIt()"></p>"#
        )
    }

    @Test func testRendersFormEventAttribute() async throws {
        try await HTMLAssertEqual(
            p(.on(.blur, "doIt()")) {},
            #"<p onblur="doIt()"></p>"#
        )
    }

    @Test func testRendersMetaCharset() async throws {
        try await HTMLAssertEqual(
            meta(.charset(.utf8)),
            #"<meta charset="UTF-8">"#
        )
    }

    @Test func testRendersRequired() async throws {
        try await HTMLAssertEqual(
            input(.type(.text), .required),
            #"<input type="text" required>"#
        )
    }

    @Test func testRendersAttributesArray() async throws {
        try await HTMLAssertEqual(
            p(attributes: [.id("foo"), .class("foo"), .hidden]) {},
            #"<p id="foo" class="foo" hidden></p>"#
        )
    }

    @Test func testRendersAttributesArrayOnVoidElement() async throws {
        try await HTMLAssertEqual(
            input(attributes: [.type(.text), .required]),
            #"<input type="text" required>"#
        )
    }

    @Test func testRendersAppliedConditionalAttributesArray() async throws {
        try await HTMLAssertEqual(
            img(.id("1")).attributes(contentsOf: [.class("2"), .id("no")], when: false).attributes(contentsOf: [.style("2")], when: true),
            #"<img id="1" style="2">"#
        )
    }

    @Test func testRendersWidthAndHeightAttributes() async throws {
        try await HTMLAssertEqual(
            img(.width(100), .height(200)),
            #"<img width="100" height="200">"#
        )
    }

    @Test func testRendersAltForImg() async throws {
        try await HTMLAssertEqual(
            img(.src("/path/to/dog.jpeg"), .alt("A happy dog"), .width(200), .height(200)),
            #"<img src="/path/to/dog.jpeg" alt="A happy dog" width="200" height="200">"#
        )
    }

    @Test func testRendersNumericInputConstraints() async throws {
        try await HTMLAssertEqual(
            input(.type(.number), .min(0), .max(10.5), .step(0.5)),
            #"<input type="number" min="0" max="10.5" step="0.5">"#
        )
    }

    @Test func testRendersDateInputConstraints() async throws {
        try await HTMLAssertEqual(
            input(.type(.date), .min("2025-01-01"), .max("2025-12-31"), .step(.any)),
            #"<input type="date" min="2025-01-01" max="2025-12-31" step="any">"#
        )
    }

    @Test func testRendersTextInputConstraints() async throws {
        try await HTMLAssertEqual(
            input(.type(.text), .minlength(2), .maxlength(20), .size(30), .pattern("[a-z]+"), .readonly, .list("suggestions")),
            #"<input type="text" minlength="2" maxlength="20" size="30" pattern="[a-z]+" readonly list="suggestions">"#
        )
    }

    @Test func testRendersTextareaAttributes() async throws {
        try await HTMLAssertEqual(
            textarea(.rows(4), .cols(40), .wrap(.soft), .maxlength(100)) {},
            #"<textarea rows="4" cols="40" wrap="soft" maxlength="100"></textarea>"#
        )
    }

    @Test func testRendersSelectAttributes() async throws {
        try await HTMLAssertEqual(
            select(.multiple, .size(3)) {},
            #"<select multiple size="3"></select>"#
        )
    }

    @Test func testRendersFormEncodingAttributes() async throws {
        try await HTMLAssertEqual(
            form(.method(.post), .enctype(.multipartFormData), .novalidate) {},
            #"<form method="post" enctype="multipart/form-data" novalidate></form>"#
        )
    }

    @Test func testRendersMeterAndProgressAttributes() async throws {
        try await HTMLAssertEqual(
            meter(.min(0), .max(100), .low(20), .high(80), .optimum(90), .value(75)) {},
            #"<meter min="0" max="100" low="20" high="80" optimum="90" value="75"></meter>"#
        )

        try await HTMLAssertEqual(
            progress(.value(0.5), .max(1)) {},
            #"<progress value="0.5" max="1"></progress>"#
        )
    }
}
