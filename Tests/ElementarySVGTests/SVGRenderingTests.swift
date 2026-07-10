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
                    .stroke("blue"),
                    .strokeWidth(2),
                    .strokeLinecap("round"),
                    .strokeLinejoin("round")
                )
            },
            """
            <svg viewBox="0 0 24 24" width="24" height="24"><title>Checkmark</title><path d="M20 6 9 17l-5-5" fill="none" stroke="blue" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" /></svg>
            """
        )
    }
    @Test func preservesAttributeValuesOnSelfClosingSVGElement() {
        #expect(#"<path data-label="A&amp;&quot;B" />"# == SVG.path(.custom(name: "data-label", value: "A&\"B")).render())
    }

    @Test func rendersNestedGroupsAndAccessibilityText() async throws {
        try await HTMLAssertEqual(
            SVG.svg(.viewBox(0, 0, 10, 10), .role("img")) {
                SVG.title { "A & B" }
                SVG.desc { "Use <carefully>" }
                SVG.g(.id("layer")) {
                    SVG.circle(.cx(5), .cy(5), .r(4), .fill("red"))
                }
            },
            """
            <svg viewBox="0 0 10 10" role="img"><title>A &amp; B</title><desc>Use &lt;carefully&gt;</desc><g id="layer"><circle cx="5" cy="5" r="4" fill="red" /></g></svg>
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
                        SVG.line(.x1(0), .y1(SVGLength(item)), .x2(10), .y2(SVGLength(item)))
                    }
                    ForEach(items) { item in
                        SVG.path(.d("M0 \(item) L10 \(item)"))
                    }
                }
            },
            """
            <svg><rect x="1" y="1" width="8" height="8" /><line x1="0" y1="2" x2="10" y2="2" /><line x1="0" y1="4" x2="10" y2="4" /><path d="M0 2 L10 2" /><path d="M0 4 L10 4" /></svg>
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
            <div><svg viewBox="0 0 1 1"><rect width="1" height="1" /></svg></div>
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
            <svg><g class="base active" style="stroke:red;fill:none"><path d="M0 0" /></g></svg>
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

    @Test func rendersSharedAndElementConstrainedSVGAttributes() async throws {
        try await HTMLAssertEqual(
            SVG.svg(.x(0), .y(0)) {
                SVG.defs {
                    SVG.symbol(
                        .id("icon"),
                        .x(1),
                        .y(2),
                        .width(16),
                        .height(16),
                        .viewBox(0, 0, 16, 16),
                        .preserveAspectRatio("xMidYMid meet")
                    ) {
                        SVG.path(.d("M0 0h16v16H0z"), .fillRule("evenodd"), .clipRule("evenodd"))
                    }
                    SVG.linearGradient(.id("fade"), .x1(0), .y1(0), .x2(1), .y2(1), .gradientUnits("objectBoundingBox")) {
                        SVG.stop(.offset(.percent(0)), .stopColor("red"), .stopOpacity(0.5))
                        SVG.stop(.offset(.percent(100)), .stopColor("blue"), .stopOpacity(1.0))
                    }
                    SVG.radialGradient(.id("spot"), .cx(.percent(50)), .cy(.percent(50)), .r(.percent(75))) {
                        SVG.stop(.offset(0), .stopColor("white"))
                    }
                    SVG.clipPath(.id("clip"), .clipPathUnits("objectBoundingBox")) {
                        SVG.path(.d("M0 0h1v1H0z"))
                    }
                    SVG.mask(
                        .id("mask"),
                        .x(.percent(0)),
                        .y(.percent(0)),
                        .width(.percent(100)),
                        .height(.percent(100)),
                        .maskType("luminance"),
                        .maskUnits("objectBoundingBox"),
                        .maskContentUnits("userSpaceOnUse")
                    ) {
                        SVG.rect(.width(16), .height(16), .fill("white"), .fillOpacity(0.75))
                    }
                }
                SVG.use(.href("#icon"), .x(4), .y(4), .width(16), .height(16), .stroke("black"), .strokeOpacity(0.25))
            },
            """
            <svg x="0" y="0"><defs><symbol id="icon" x="1" y="2" width="16" height="16" viewBox="0 0 16 16" preserveAspectRatio="xMidYMid meet"><path d="M0 0h16v16H0z" fill-rule="evenodd" clip-rule="evenodd" /></symbol><linearGradient id="fade" x1="0" y1="0" x2="1" y2="1" gradientUnits="objectBoundingBox"><stop offset="0%" stop-color="red" stop-opacity="0.5" /><stop offset="100%" stop-color="blue" stop-opacity="1.0" /></linearGradient><radialGradient id="spot" cx="50%" cy="50%" r="75%"><stop offset="0" stop-color="white" /></radialGradient><clipPath id="clip" clipPathUnits="objectBoundingBox"><path d="M0 0h1v1H0z" /></clipPath><mask id="mask" x="0%" y="0%" width="100%" height="100%" mask-type="luminance" maskUnits="objectBoundingBox" maskContentUnits="userSpaceOnUse"><rect width="16" height="16" fill="white" fill-opacity="0.75" /></mask></defs><use href="#icon" x="4" y="4" width="16" height="16" stroke="black" stroke-opacity="0.25" /></svg>
            """
        )
    }

    @Test func rendersReusableSVGContentWithBody() async throws {
        try await HTMLAssertEqual(
            SVG.svg {
                CheckmarkIcon()
            },
            """
            <svg><path d="M20 6 9 17l-5-5" fill="none" stroke="currentColor" /></svg>
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
            <svg><path d="M20 6 9 17l-5-5" fill="none" stroke="currentColor" id="check" class="primary" /></svg>
            """
        )
    }

    @Test func selfClosesElementWithKnownEmptyOptionalContent() {
        #expect(
            #"<g />"#
                == SVG.g {
                    if false {
                        SVG.path(.d("M0 0"))
                    }
                }.render()
        )
    }

    @Test func selfClosesElementWithKnownEmptyConditionalContent() {
        let shouldRender = false

        #expect(
            #"<g />"#
                == SVG.g {
                    if shouldRender {
                        SVG.path(.d("M0 0"))
                    } else {
                        EmptyContent()
                    }
                }.render()
        )
    }

    @Test func keepsElementPairedWithKnownNonEmptyConditionalContent() {
        let shouldRender = true

        #expect(
            #"<g><path d="M0 0" /></g>"#
                == SVG.g {
                    if shouldRender {
                        SVG.path(.d("M0 0"))
                    } else {
                        EmptyContent()
                    }
                }.render()
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
                <path d="M0 0" />
              </g>
            </svg>
            """
        )
    }

    @Test func rendersAsyncSVGContent() async throws {
        try await HTMLAssertEqualAsyncOnly(
            SVG.svg {
                AsyncContent {
                    SVG.path(.d("M0 0"))
                }
            },
            "<svg><path d=\"M0 0\" /></svg>"
        )
    }

    @Test func rendersAsyncNestedSVGInitializerWithAttributeArray() async throws {
        try await HTMLAssertEqualAsyncOnly(
            SVG.svg {
                SVG.g(attributes: [.id("x")]) {
                    AsyncContent {
                        let pathData = await asyncPathData("M2 2")
                        SVG.path(.d(pathData)) {
                            SVG.title { "Async Path" }
                        }
                    }
                }
            },
            "<svg><g id=\"x\"><path d=\"M2 2\"><title>Async Path</title></path></g></svg>"
        )
    }
}

private func HTMLAssertEqual(_ html: some HTML, _ expected: String, sourceLocation: SourceLocation = #_sourceLocation) async throws {
    #expect(expected == html.render(), sourceLocation: sourceLocation)

    try await HTMLAssertEqualAsyncOnly(html, expected, sourceLocation: sourceLocation)
}

private func HTMLAssertEqualAsyncOnly(_ html: some HTML, _ expected: String, sourceLocation: SourceLocation = #_sourceLocation) async throws
{
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
    var body: some SVGContent {
        SVG.path(
            .d("M20 6 9 17l-5-5"),
            .fill(.none),
            .stroke("currentColor")
        )
    }
}
