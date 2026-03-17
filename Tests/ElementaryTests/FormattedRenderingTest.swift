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
                    svg {}
                    img()
                }
            },
            """
            <div>
              <br>
              <img>
              <img>
              <p>
                <svg></svg>
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
