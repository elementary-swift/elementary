import Elementary
import ElementarySVG
import Testing

struct SVGRenderingTests {
    @Test func rendersRootSVGAndEmptyShape() async throws {
        try await SVGAssertEqual(
            SVG.svg(.viewBox(0, 0, 24, 24), .width(24), .height(24)) {
                SVG.title { "Checkmark" }
                SVG.path(
                    .d("M20 6 9 17l-5-5"),
                    .fill(.none),
                    .stroke("blue"),
                    .strokeWidth(2),
                    .strokeLinecap(.round),
                    .strokeLinejoin(.round)
                )
            },
            """
            <svg viewBox="0 0 24 24" width="24" height="24"><title>Checkmark</title><path d="M20 6 9 17l-5-5" fill="none" stroke="blue" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" /></svg>
            """
        )
    }
    @Test func preservesAttributeValuesOnSelfClosingSVGElement() async throws {
        try await SVGAssertEqual(
            SVG.path(.custom(name: "data-label", value: "A&\"B")),
            #"<path data-label="A&amp;&quot;B" />"#
        )
    }

    @Test func rendersNestedGroupsAndAccessibilityText() async throws {
        try await SVGAssertEqual(
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

        try await SVGAssertEqual(
            SVG.svg {
                Group {
                    if true {
                        SVG.rect(.x(1), .y(1), .width(8), .height(8))
                    } else {
                        SVG.circle(.cx(5), .cy(5), .r(5))
                    }
                    for item in items {
                        SVG.line(.x1(0), .y1(SVGAttributeValue.Length(item)), .x2(10), .y2(SVGAttributeValue.Length(item)))
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
        try await SVGAssertEqual(
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
        try await SVGAssertEqual(
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
        try await SVGAssertEqual(
            SVG.svg(.custom(name: "data-label", value: "Grüße & \"SVG\"")) {
                SVG.text { "café" }
            },
            """
            <svg data-label="Grüße &amp; &quot;SVG&quot;"><text>café</text></svg>
            """
        )
    }

    @Test func rendersSharedAndElementConstrainedSVGAttributes() async throws {
        try await SVGAssertEqual(
            SVG.svg(.x(0), .y(0)) {
                SVG.defs {
                    SVG.symbol(
                        .id("icon"),
                        .x(1),
                        .y(2),
                        .width(16),
                        .height(16),
                        .viewBox(0, 0, 16, 16),
                        .preserveAspectRatio(.xMidYMid())
                    ) {
                        SVG.path(.d("M0 0h16v16H0z"), .fillRule(.evenodd), .clipRule(.evenodd))
                    }
                    SVG.linearGradient(.id("fade"), .x1(0), .y1(0), .x2(1), .y2(1), .gradientUnits(.objectBoundingBox)) {
                        SVG.stop(.offset(.percent(0)), .stopColor("red"), .stopOpacity(0.5))
                        SVG.stop(.offset(.percent(100)), .stopColor("blue"), .stopOpacity(1.0))
                    }
                    SVG.radialGradient(.id("spot"), .cx(.percent(50)), .cy(.percent(50)), .r(.percent(75))) {
                        SVG.stop(.offset(0), .stopColor("white"))
                    }
                    SVG.clipPath(.id("clip"), .clipPathUnits(.objectBoundingBox)) {
                        SVG.path(.d("M0 0h1v1H0z"))
                    }
                    SVG.mask(
                        .id("mask"),
                        .x(.percent(0)),
                        .y(.percent(0)),
                        .width(.percent(100)),
                        .height(.percent(100)),
                        .maskType(.luminance),
                        .maskUnits(.objectBoundingBox),
                        .maskContentUnits(.userSpaceOnUse)
                    ) {
                        SVG.rect(.width(16), .height(16), .fill("white"), .fillOpacity(0.75))
                    }
                }
                SVG.use(.href("#icon"), .x(4), .y(4), .width(16), .height(16), .stroke("black"), .strokeOpacity(0.25))
            },
            """
            <svg x="0" y="0"><defs><symbol id="icon" x="1" y="2" width="16" height="16" viewBox="0 0 16 16" preserveAspectRatio="xMidYMid"><path d="M0 0h16v16H0z" fill-rule="evenodd" clip-rule="evenodd" /></symbol><linearGradient id="fade" x1="0" y1="0" x2="1" y2="1" gradientUnits="objectBoundingBox"><stop offset="0%" stop-color="red" stop-opacity="0.5" /><stop offset="100%" stop-color="blue" stop-opacity="1.0" /></linearGradient><radialGradient id="spot" cx="50%" cy="50%" r="75%"><stop offset="0" stop-color="white" /></radialGradient><clipPath id="clip" clipPathUnits="objectBoundingBox"><path d="M0 0h1v1H0z" /></clipPath><mask id="mask" x="0%" y="0%" width="100%" height="100%" mask-type="luminance" maskUnits="objectBoundingBox" maskContentUnits="userSpaceOnUse"><rect width="16" height="16" fill="white" fill-opacity="0.75" /></mask></defs><use href="#icon" x="4" y="4" width="16" height="16" stroke="black" stroke-opacity="0.25" /></svg>
            """
        )
    }

    @Test func rendersAdditionalPresentationAttributesAndReferences() async throws {
        try await SVGAssertEqual(
            SVG.svg {
                SVG.defs {
                    SVG.clipPath(.id("clip"), .clipPathUnits(.userSpaceOnUse), .transform("translate(1 2)")) {
                        SVG.rect(.width(8), .height(8))
                    }
                    SVG.mask(.id("mask")) {
                        SVG.rect(.width(8), .height(8), .fill("white"))
                    }
                }
                SVG.path(
                    .d("M0 0h8v8H0z"),
                    .stroke("black"),
                    .strokeDasharray("2 1"),
                    .strokeDashoffset(0.5),
                    .strokeMiterlimit(8),
                    .clipPath("url(#clip)"),
                    .mask("url(#mask)")
                )
            },
            """
            <svg><defs><clipPath id="clip" clipPathUnits="userSpaceOnUse" transform="translate(1 2)"><rect width="8" height="8" /></clipPath><mask id="mask"><rect width="8" height="8" fill="white" /></mask></defs><path d="M0 0h8v8H0z" stroke="black" stroke-dasharray="2 1" stroke-dashoffset="0.5" stroke-miterlimit="8" clip-path="url(#clip)" mask="url(#mask)" /></svg>
            """
        )
    }

    @Test func rendersAdditionalGradientAndTextAttributes() async throws {
        try await SVGAssertEqual(
            SVG.svg {
                SVG.defs {
                    SVG.linearGradient(
                        .id("shine"),
                        .gradientUnits(.userSpaceOnUse),
                        .gradientTransform("rotate(45)"),
                        .spreadMethod(.reflect)
                    ) {
                        SVG.stop(.offset(0), .stopColor("white"))
                    }
                    SVG.radialGradient(
                        .id("spot"),
                        .cx(.percent(50)),
                        .cy(.percent(50)),
                        .r(.percent(40)),
                        .fx(.percent(25)),
                        .fy(.percent(30)),
                        .fr(.percent(5)),
                        .spreadMethod(.repeat)
                    ) {
                        SVG.stop(.offset(.percent(100)), .stopColor("black"))
                    }
                }
                SVG.text(
                    .fontFamily("Inter"),
                    .fontSize(12),
                    .fontWeight("700"),
                    .fontStyle("italic"),
                    .fontVariant("small-caps"),
                    .letterSpacing(1),
                    .wordSpacing(2),
                    .textDecoration("underline")
                ) {
                    "Hello"
                }
            },
            """
            <svg><defs><linearGradient id="shine" gradientUnits="userSpaceOnUse" gradientTransform="rotate(45)" spreadMethod="reflect"><stop offset="0" stop-color="white" /></linearGradient><radialGradient id="spot" cx="50%" cy="50%" r="40%" fx="25%" fy="30%" fr="5%" spreadMethod="repeat"><stop offset="100%" stop-color="black" /></radialGradient></defs><text font-family="Inter" font-size="12" font-weight="700" font-style="italic" font-variant="small-caps" letter-spacing="1" word-spacing="2" text-decoration="underline">Hello</text></svg>
            """
        )
    }

    @Test func rendersImagePatternAndMarkerElements() async throws {
        try await SVGAssertEqual(
            SVG.svg {
                SVG.defs {
                    SVG.pattern(
                        .id("tiles"),
                        .x(0),
                        .y(0),
                        .width(4),
                        .height(4),
                        .viewBox(0, 0, 4, 4),
                        .preserveAspectRatio(.xMidYMid()),
                        .patternUnits(.userSpaceOnUse),
                        .patternContentUnits(.userSpaceOnUse),
                        .patternTransform("rotate(45)")
                    ) {
                        SVG.rect(.width(4), .height(4), .fill("gold"))
                    }
                    SVG.marker(
                        .id("arrow"),
                        .markerWidth(6),
                        .markerHeight(6),
                        .markerUnits(.strokeWidth),
                        .refX(5),
                        .refY(3),
                        .orient(.autoStartReverse),
                        .viewBox(0, 0, 6, 6),
                        .fill("currentColor")
                    ) {
                        SVG.path(.d("M0 0L6 3L0 6z"))
                    }
                }
                SVG.image(
                    .href("icon.png"),
                    .x(1),
                    .y(2),
                    .width(16),
                    .height(16),
                    .preserveAspectRatio(.xMidYMid(.slice)),
                    .opacity(0.5)
                )
            },
            """
            <svg><defs><pattern id="tiles" x="0" y="0" width="4" height="4" viewBox="0 0 4 4" preserveAspectRatio="xMidYMid" patternUnits="userSpaceOnUse" patternContentUnits="userSpaceOnUse" patternTransform="rotate(45)"><rect width="4" height="4" fill="gold" /></pattern><marker id="arrow" markerWidth="6" markerHeight="6" markerUnits="strokeWidth" refX="5" refY="3" orient="auto-start-reverse" viewBox="0 0 6 6" fill="currentColor"><path d="M0 0L6 3L0 6z" /></marker></defs><image href="icon.png" x="1" y="2" width="16" height="16" preserveAspectRatio="xMidYMid slice" opacity="0.5" /></svg>
            """
        )
    }

    @Test func rendersLinksStylesAndTextPathElements() async throws {
        try await SVGAssertEqual(
            SVG.svg(.viewBox(0, 0, 120, 40)) {
                SVG.style {
                    ".accent{fill:currentColor}"
                }
                SVG.defs {
                    SVG.path(.id("baseline"), .d("M0 30 C 30 0, 90 0, 120 30"))
                }
                SVG.a(.href("https://example.com"), .target(.blank), .fill("tomato")) {
                    SVG.circle(.cx(8), .cy(8), .r(4))
                }
                SVG.text {
                    SVG.textPath(
                        .href("#baseline"),
                        .startOffset(.percent(50)),
                        .method(.align),
                        .spacing(.exact),
                        .textAnchor("middle")
                    ) {
                        "Hello"
                    }
                }
            },
            """
            <svg viewBox="0 0 120 40"><style>.accent{fill:currentColor}</style><defs><path id="baseline" d="M0 30 C 30 0, 90 0, 120 30" /></defs><a href="https://example.com" target="_blank" fill="tomato"><circle cx="8" cy="8" r="4" /></a><text><textPath href="#baseline" startOffset="50%" method="align" spacing="exact" text-anchor="middle">Hello</textPath></text></svg>
            """
        )
    }

    @Test func rendersRawSVGContent() async throws {
        try await SVGAssertEqual(
            SVG.style {
                SVGRaw(#".label::after{content:"&"}"#)
            },
            #"<style>.label::after{content:"&"}</style>"#
        )
    }

    @Test func rendersStringLiteralSVGAttributeValues() async throws {
        try await SVGAssertEqual(
            SVG.marker(
                .orient("45deg"),
                .markerUnits("customUnits"),
                .preserveAspectRatio("defer xMaxYMax slice")
            ) {
                SVG.path(.d("M0 0"))
            },
            #"<marker orient="45deg" markerUnits="customUnits" preserveAspectRatio="defer xMaxYMax slice"><path d="M0 0" /></marker>"#
        )
    }

    @Test func rendersStringLiteralSVGLinkAndTextPathAttributeValues() async throws {
        try await SVGAssertEqual(
            SVG.text {
                SVG.textPath(.href("#curve"), .method("customMethod"), .spacing("customSpacing")) {
                    "Hi"
                }
            },
            ##"<text><textPath href="#curve" method="customMethod" spacing="customSpacing">Hi</textPath></text>"##
        )
        try await SVGAssertEqual(
            SVG.a(.href("/next"), .target("frame")) {
                SVG.path(.d("M0 0"))
            },
            #"<a href="/next" target="frame"><path d="M0 0" /></a>"#
        )
    }

    @Test func rendersFormattedLinksAndTextPathInline() {
        SVGFormattedAssertEqual(
            SVG.svg {
                SVG.text {
                    SVG.a(.href("/label")) {
                        SVG.textPath(.href("#curve")) {
                            "Label"
                        }
                    }
                }
            },
            """
            <svg>
              <text><a href="/label"><textPath href="#curve">Label</textPath></a></text>
            </svg>
            """
        )
    }

    @Test func rendersReusableSVGContentWithBody() async throws {
        try await SVGAssertEqual(
            SVG.svg {
                CheckmarkIcon()
            },
            """
            <svg><path d="M20 6 9 17l-5-5" fill="none" stroke="currentColor" /></svg>
            """
        )
    }

    @Test func wrapsReusableSVGContentWithAttributes() async throws {
        try await SVGAssertEqual(
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

    @Test func selfClosesElementWithKnownEmptyOptionalContent() async throws {
        try await SVGAssertEqual(
            SVG.g {
                if false {
                    SVG.path(.d("M0 0"))
                }
            },
            #"<g />"#
        )
    }

    @Test func selfClosesElementWithKnownEmptyConditionalContent() async throws {
        let shouldRender = false

        try await SVGAssertEqual(
            SVG.g {
                if shouldRender {
                    SVG.path(.d("M0 0"))
                } else {
                    EmptyContent()
                }
            },
            #"<g />"#
        )
    }

    @Test func keepsElementPairedWithKnownNonEmptyConditionalContent() async throws {
        let shouldRender = true

        try await SVGAssertEqual(
            SVG.g {
                if shouldRender {
                    SVG.path(.d("M0 0"))
                } else {
                    EmptyContent()
                }
            },
            #"<g><path d="M0 0" /></g>"#
        )
    }

    @Test func rendersFormattedSVG() {
        SVGFormattedAssertEqual(
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

    @Test func rendersFormattedTextLikeSVGElementsInline() {
        SVGFormattedAssertEqual(
            SVG.svg {
                SVG.text(.x(0), .y(10)) {
                    SVG.tspan { "one" }
                    "Hello"
                    SVG.tspan { "two" }
                }
            },
            #"""
            <svg>
              <text x="0" y="10"><tspan>one</tspan>Hello<tspan>two</tspan></text>
            </svg>
            """#
        )
    }

    @Test func rendersAsyncSVGContent() async throws {
        try await SVGAssertEqualAsyncOnly(
            SVG.svg {
                AsyncContent {
                    SVG.path(.d("M0 0"))
                }
            },
            "<svg><path d=\"M0 0\" /></svg>"
        )
    }

    @Test func rendersAsyncNestedSVGInitializerWithAttributeArray() async throws {
        try await SVGAssertEqualAsyncOnly(
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

private func SVGAssertEqual(_ html: some MarkupContent, _ expected: String, sourceLocation: SourceLocation = #_sourceLocation) async throws
{
    #expect(expected == html.render(), sourceLocation: sourceLocation)

    try await SVGAssertEqualAsyncOnly(html, expected, sourceLocation: sourceLocation)
}

private func SVGAssertEqualAsyncOnly(
    _ html: some MarkupContent,
    _ expected: String,
    sourceLocation: SourceLocation = #_sourceLocation
) async throws {
    let asyncText = try await html.renderAsync()
    #expect(expected == asyncText, sourceLocation: sourceLocation)
}

private func SVGFormattedAssertEqual(_ html: some MarkupContent, _ expected: String, sourceLocation: SourceLocation = #_sourceLocation) {
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
