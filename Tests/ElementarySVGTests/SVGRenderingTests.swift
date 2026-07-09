import Elementary
import ElementarySVG
import Testing

struct SVGRenderingTests {
    @Test func rendersRootSVGAndEmptyShape() async throws {
        try await HTMLAssertEqual(
            SVG.svg(.viewBox(0, 0, 24, 24), .width(24), .height(24)) {
                SVG.title { "Checkmark" }
                SVG.path(
                    .d("M20 6 9 17l-5-5"),
                    .fill(.none),
                    .stroke(.currentColor),
                    .strokeWidth(2),
                    .strokeLinecap("round"),
                    .strokeLinejoin("round")
                )
            },
            """
            <svg viewBox="0 0 24 24" width="24" height="24"><title>Checkmark</title><path d="M20 6 9 17l-5-5" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"></path></svg>
            """
        )
    }

    @Test func rendersNestedGroupsAndAccessibilityText() async throws {
        try await HTMLAssertEqual(
            SVG.svg(.viewBox(0, 0, 10, 10)) {
                SVG.title { "A & B" }
                SVG.desc { "Use <carefully>" }
                SVG.g(.id("layer")) {
                    SVG.circle(.cx(5), .cy(5), .r(4), .fill("red"))
                }
            },
            """
            <svg viewBox="0 0 10 10"><title>A &amp; B</title><desc>Use &lt;carefully&gt;</desc><g id="layer"><circle cx="5" cy="5" r="4" fill="red"></circle></g></svg>
            """
        )
    }

    @Test func rendersBuilderStructuresInsideSVG() async throws {
        let items = [2, 4]

        try await HTMLAssertEqual(
            SVG.svg {
                Group {
                    if true {
                        SVG.rect(.x(1), .y(1), .width(8), .height(8))
                    } else {
                        SVG.circle(.cx(5), .cy(5), .r(5))
                    }
                    for item in items {
                        SVG.line(.x1(0), .y1(item), .x2(10), .y2(item))
                    }
                    ForEach(items) { item in
                        SVG.path(.d("M0 \(item) L10 \(item)"))
                    }
                }
            },
            """
            <svg><rect x="1" y="1" width="8" height="8"></rect><line x1="0" y1="2" x2="10" y2="2"></line><line x1="0" y1="4" x2="10" y2="4"></line><path d="M0 2 L10 2"></path><path d="M0 4 L10 4"></path></svg>
            """
        )
    }

    @Test func rendersSVGEmbeddedInHTML() async throws {
        try await HTMLAssertEqual(
            div {
                SVG.svg(.viewBox(0, 0, 1, 1)) {
                    SVG.rect(.width(1), .height(1))
                }
            },
            """
            <div><svg viewBox="0 0 1 1"><rect width="1" height="1"></rect></svg></div>
            """
        )
    }

    @Test func mergesClassAndStyleAttributes() async throws {
        try await HTMLAssertEqual(
            SVG.svg {
                SVG.g(.class("base"), .style("stroke:red")) {
                    SVG.path(.d("M0 0"))
                }
                .attributes(.class("active"))
                .attributes(.style(["fill": "none"]))
            },
            """
            <svg><g class="base active" style="stroke:red;fill:none"><path d="M0 0"></path></g></svg>
            """
        )
    }

    @Test func escapesAttributeValuesAsUTF8() async throws {
        try await HTMLAssertEqual(
            SVG.svg(.custom(name: "data-label", value: "Grüße & \"SVG\"")) {
                SVG.text { "café" }
            },
            """
            <svg data-label="Grüße &amp; &quot;SVG&quot;"><text>café</text></svg>
            """
        )
    }

    @Test func rendersReusableSVGContentWithBody() async throws {
        try await HTMLAssertEqual(
            SVG.svg {
                CheckmarkIcon()
            },
            """
            <svg><path d="M20 6 9 17l-5-5" fill="none" stroke="currentColor"></path></svg>
            """
        )
    }

    @Test func wrapsReusableSVGContentWithAttributes() async throws {
        try await HTMLAssertEqual(
            SVG.svg {
                CheckmarkIcon()
                    .attributes(.id("check"))
                    .attributes(.class("primary"))
            },
            """
            <svg><path d="M20 6 9 17l-5-5" fill="none" stroke="currentColor" id="check" class="primary"></path></svg>
            """
        )
    }

    @Test func rendersFormattedSVG() {
        HTMLFormattedAssertEqual(
            SVG.svg {
                SVG.g {
                    SVG.path(.d("M0 0"))
                }
            },
            """
            <svg>
              <g>
                <path d="M0 0"></path>
              </g>
            </svg>
            """
        )
    }

    #if !hasFeature(Embedded)
    @Test func rendersAsyncSVGContent() async throws {
        try await HTMLAssertEqualAsyncOnly(
            SVG.svg {
                AsyncContent {
                    SVG.path(.d("M0 0"))
                }
            },
            "<svg><path d=\"M0 0\"></path></svg>"
        )
    }

    @Test func rendersAsyncRootSVGInitializer() async throws {
        try await HTMLAssertEqualAsyncOnly(
            SVG.svg {
                let pathData = await asyncPathData("M0 0")
                SVG.path(.d(pathData))
            },
            "<svg><path d=\"M0 0\"></path></svg>"
        )
    }

    @Test func rendersAsyncNestedSVGInitializerWithVariadicAttributes() async throws {
        try await HTMLAssertEqualAsyncOnly(
            SVG.svg {
                SVG.g(.id("x")) {
                    let pathData = await asyncPathData("M1 1")
                    SVG.path(.d(pathData))
                }
            },
            "<svg><g id=\"x\"><path d=\"M1 1\"></path></g></svg>"
        )
    }

    @Test func rendersAsyncNestedSVGInitializerWithAttributeArray() async throws {
        try await HTMLAssertEqualAsyncOnly(
            SVG.svg {
                SVG.g(attributes: [.id("x")]) {
                    let pathData = await asyncPathData("M2 2")
                    SVG.path(.d(pathData))
                }
            },
            "<svg><g id=\"x\"><path d=\"M2 2\"></path></g></svg>"
        )
    }
    #endif
}

private func HTMLAssertEqual(_ html: some HTML, _ expected: String, sourceLocation: SourceLocation = #_sourceLocation) async throws {
    #expect(expected == html.render(), sourceLocation: sourceLocation)

    try await HTMLAssertEqualAsyncOnly(html, expected, sourceLocation: sourceLocation)
}

private func HTMLAssertEqualAsyncOnly(_ html: some HTML, _ expected: String, sourceLocation: SourceLocation = #_sourceLocation) async throws {
    let asyncText = try await html.renderAsync()
    #expect(expected == asyncText, sourceLocation: sourceLocation)
}

private func HTMLFormattedAssertEqual(_ html: some HTML, _ expected: String, sourceLocation: SourceLocation = #_sourceLocation) {
    #expect(expected == html.renderFormatted(), sourceLocation: sourceLocation)
}

private func asyncPathData(_ value: String) async -> String {
    await Task.yield()
    return value
}

private struct CheckmarkIcon: SVGContent {
    var body: SVG.path {
        SVG.path(
            .d("M20 6 9 17l-5-5"),
            .fill(.none),
            .stroke(.currentColor)
        )
    }
}
