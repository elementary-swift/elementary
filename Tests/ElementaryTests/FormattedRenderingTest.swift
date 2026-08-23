import Elementary
import Testing

struct FormatedRenderingTests {
    @Test func testFormatsBlocks() {
        HTMLFormattedAssertEqual(
            div {
                div {
                    p {}; p {}
                }
            },
            """
            <div>
              <div>
                <p></p>
                <p></p>
              </div>
            </div>
            """
        )
    }

    @Test func testFormatsInlineTextAndRaw() {
        HTMLFormattedAssertEqual(
            div {
                div {
                    p { "Hello&" }; p { HTMLRaw("World&") }
                }
            },
            """
            <div>
              <div>
                <p>Hello&amp;</p>
                <p>World&</p>
              </div>
            </div>
            """
        )
    }

    @Test func testFormatsLineBreaks() {
        HTMLFormattedAssertEqual(
            p {
                """
                This,
                is <a>
                  multiline test.
                """
            },
            """
            <p>
              This,
              is &lt;a&gt;
                multiline test.
            </p>
            """
        )
    }

    @Test func testFormatsComments() {
        HTMLFormattedAssertEqual(
            div { HTMLComment("Hello") },
            """
            <div><!--Hello--></div>
            """
        )
    }

    @Test func testFormatsMixedContextInBlock() {
        HTMLFormattedAssertEqual(
            div {
                HTMLComment("Hello")
                p { "World" }
            },
            """
            <div>
              <!--Hello-->
              <p>World</p>
            </div>
            """
        )
    }

    @Test func testFormatsInlineElements() {
        HTMLFormattedAssertEqual(
            div {
                "Hello, "
                span { "Wor" }
                b { "ld" }
            },
            """
            <div>Hello, <span>Wor</span><b>ld</b></div>
            """
        )
    }

    @Test func testFormatsUnpairedTags() {
        HTMLFormattedAssertEqual(
            div {
                "Hello"
                br()
                "World"
            },
            """
            <div>
              Hello
              <br>
              World
            </div>
            """
        )
    }

    @Test func testManyUnpairedTags() {
        HTMLFormattedAssertEqual(
            div {
                br()
                img()
                img()
                p {
                    span {}
                    img()
                }
            },
            """
            <div>
              <br>
              <img>
              <img>
              <p>
                <span></span>
                <img>
              </p>
            </div>
            """
        )
    }

    @Test func testFormatsMixed() {
        HTMLFormattedAssertEqual(
            div {
                "Hello"
                p { "World" }
                "Ok"
                img()
                "Ok"

            },
            """
            <div>
              Hello
              <p>World</p>
              Ok
              <img>
              Ok
            </div>
            """
        )
    }

    @Test func testFormatsInlineElementWithTextAfterBlockSibling() {
        HTMLFormattedAssertEqual(
            div {
                p { "a" }
                span { "hi" }
            },
            """
            <div>
              <p>a</p>
              <span>hi</span>
            </div>
            """
        )
    }

    @Test func testFormatsBlockSiblingAfterInlineAfterBlockSibling() {
        HTMLFormattedAssertEqual(
            div {
                p { "a" }
                span { "hi" }
                p { "b" }
            },
            """
            <div>
              <p>a</p>
              <span>hi</span>
              <p>b</p>
            </div>
            """
        )
    }

    @Test func testFormatsSelfClosingTagAfterInlineAfterBlockSibling() {
        HTMLFormattedAssertEqual(
            div {
                p { "a" }
                span { "hi" }
                br()
            },
            """
            <div>
              <p>a</p>
              <span>hi</span>
              <br>
            </div>
            """
        )
    }

    @Test func testFormatsConsecutiveInlineSiblingsAfterBlockSibling() {
        HTMLFormattedAssertEqual(
            div {
                p { "a" }
                span { "hi" }
                span { "bye" }
            },
            """
            <div>
              <p>a</p>
              <span>hi</span><span>bye</span>
            </div>
            """
        )
    }

    @Test func testFormatsRawInsideInlineElementAfterBlockSibling() {
        HTMLFormattedAssertEqual(
            div {
                p { "a" }
                span { HTMLRaw("<b>raw</b>") }
            },
            """
            <div>
              <p>a</p>
              <span><b>raw</b></span>
            </div>
            """
        )
    }

    @Test func testFormatsAttributes() {
        HTMLFormattedAssertEqual(
            div(.id("1")) {
                "Hello "
                span(.class("foo")) { "World" }
                p(.class("bar")) { "!" }
            },
            """
            <div id="1">
              Hello <span class="foo">World</span>
              <p class="bar">!</p>
            </div>
            """
        )
    }
}
