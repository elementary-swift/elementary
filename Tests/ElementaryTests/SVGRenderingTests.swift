import Testing
import Elementary

private struct Dot: HTML {
    var body: some HTML {
        circle(.cx("5"), .cy("5"), .r("5"), .fill("red")) {}
    }
}

struct SVGRenderingTests {
    @Test func testRendersSVGWithDimensionsAndViewBox() async throws {
        try await HTMLAssertEqual(
            svg(.width(24), .height(24), .viewBox("0 0 24 24")) {},
            #"<svg width="24" height="24" viewBox="0 0 24 24"></svg>"#
        )
    }

    @Test func testRendersPathWithDAndPresentation() async throws {
        try await HTMLAssertEqual(
            path(.d("M0 0 L10 10"), .fill("none"), .stroke("black")) {},
            #"<path d="M0 0 L10 10" fill="none" stroke="black"></path>"#
        )
    }

    @Test func testRendersCircleAttributes() async throws {
        try await HTMLAssertEqual(
            circle(.cx("50"), .cy("50"), .r("10")) {},
            #"<circle cx="50" cy="50" r="10"></circle>"#
        )
    }

    @Test func testRendersRectWithTransform() async throws {
        try await HTMLAssertEqual(
            rect(.x("10"), .y("10"), .width("80"), .height("80"), .transform("rotate(45 50 50)")) {},
            #"<rect x="10" y="10" width="80" height="80" transform="rotate(45 50 50)"></rect>"#
        )
    }

    @Test func testRendersLine() async throws {
        try await HTMLAssertEqual(
            line(.x1("0"), .y1("0"), .x2("100"), .y2("100"), .stroke("red")) {},
            #"<line x1="0" y1="0" x2="100" y2="100" stroke="red"></line>"#
        )
    }

    @Test func testRendersPolylineAndPolygon() async throws {
        try await HTMLAssertEqual(
            Group {
                polyline(.points("0,0 50,50 100,0")) {}
                polygon(.points("0,0 50,50 100,0")) {}
            },
            #"<polyline points="0,0 50,50 100,0"></polyline><polygon points="0,0 50,50 100,0"></polygon>"#
        )
    }

    @Test func testRendersText() async throws {
        try await HTMLAssertEqual(
            text { "Hi" },
            "<text>Hi</text>"
        )
    }

    @Test func testRendersDefsGradientStops() async throws {
        try await HTMLAssertEqual(
            defs {
                linearGradient(.id("g1")) {
                    stop(.offset("0%"), .custom(name: "stop-color", value: "red")) {}
                    stop(.offset("100%"), .custom(name: "stop-color", value: "blue")) {}
                }
            },
            #"<defs><linearGradient id="g1"><stop offset="0%" stop-color="red"></stop><stop offset="100%" stop-color="blue"></stop></linearGradient></defs>"#
        )
    }

    @Test func testRendersUseWithHrefAndPosition() async throws {
        try await HTMLAssertEqual(
            use(.href("#mySymbol"), .x("10"), .y("20")) {},
            ##"<use href="#mySymbol" x="10" y="20"></use>"##
        )
    }

    @Test func testRendersXmlnsAttributes() async throws {
        try await HTMLAssertEqual(
            svg(.xmlns(), .xmlnsXLink()) {},
            #"<svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink"></svg>"#
        )
    }

    // MARK: - Interop with the shared HTML machinery

    @Test func testSVGNestsInsideHTML() async throws {
        try await HTMLAssertEqual(
            div {
                svg(.viewBox("0 0 10 10")) {
                    circle(.cx("5"), .cy("5"), .r("5")) {}
                }
            },
            #"<div><svg viewBox="0 0 10 10"><circle cx="5" cy="5" r="5"></circle></svg></div>"#
        )
    }

    @Test func testForEachInsideSVG() async throws {
        try await HTMLAssertEqual(
            svg {
                ForEach(1 ... 3) { i in
                    circle(.cx("\(i)"), .cy("\(i)"), .r("1")) {}
                }
            },
            #"<svg><circle cx="1" cy="1" r="1"></circle><circle cx="2" cy="2" r="1"></circle><circle cx="3" cy="3" r="1"></circle></svg>"#
        )
    }

    @Test func testConditionalAndLoopInsideSVG() async throws {
        let showGrid = true
        let hideStroke = false
        try await HTMLAssertEqual(
            svg {
                if showGrid {
                    rect(.width("10"), .height("10")) {}
                }
                if hideStroke {
                    line(.x1("0"), .y1("0"), .x2("10"), .y2("10")) {}
                }
                for label in ["a", "b"] {
                    text { label }
                }
            },
            #"<svg><rect width="10" height="10"></rect><text>a</text><text>b</text></svg>"#
        )
    }

    @Test func testReusableSVGComponent() async throws {
        try await HTMLAssertEqual(
            svg { Dot() },
            #"<svg><circle cx="5" cy="5" r="5" fill="red"></circle></svg>"#
        )
    }

    @Test func testGroupOfSVGSiblings() async throws {
        try await HTMLAssertEqual(
            Group {
                circle(.r("1")) {}
                rect(.width("2")) {}
            },
            #"<circle r="1"></circle><rect width="2"></rect>"#
        )
    }

    // MARK: - Additional elements & attributes

    @Test func testRendersEllipse() async throws {
        try await HTMLAssertEqual(
            ellipse(.cx("50"), .cy("50"), .rx("40"), .ry("20")) {},
            #"<ellipse cx="50" cy="50" rx="40" ry="20"></ellipse>"#
        )
    }

    @Test func testRendersPresentationAttributes() async throws {
        try await HTMLAssertEqual(
            circle(.r("5"), .opacity("0.5"), .strokeLinecap("round"), .strokeDasharray("4 2"), .fillRule("evenodd")) {},
            #"<circle r="5" opacity="0.5" stroke-linecap="round" stroke-dasharray="4 2" fill-rule="evenodd"></circle>"#
        )
    }

    @Test func testRendersRadialGradient() async throws {
        try await HTMLAssertEqual(
            radialGradient(.id("r"), .cx("50%"), .cy("50%"), .r("50%")) {
                stop(.offset("0%"), .stopColor("white")) {}
                stop(.offset("100%"), .stopColor("black")) {}
            },
            #"<radialGradient id="r" cx="50%" cy="50%" r="50%"><stop offset="0%" stop-color="white"></stop><stop offset="100%" stop-color="black"></stop></radialGradient>"#
        )
    }

    @Test func testRendersSymbolAndUse() async throws {
        try await HTMLAssertEqual(
            svg {
                symbol(.id("icon"), .viewBox("0 0 10 10")) {
                    circle(.cx("5"), .cy("5"), .r("5")) {}
                }
                use(.href("#icon"), .width("20"), .height("20")) {}
            },
            ##"<svg><symbol id="icon" viewBox="0 0 10 10"><circle cx="5" cy="5" r="5"></circle></symbol><use href="#icon" width="20" height="20"></use></svg>"##
        )
    }

    @Test func testRendersClipPathReference() async throws {
        try await HTMLAssertEqual(
            svg {
                defs {
                    clipPath(.id("c")) {
                        rect(.width("10"), .height("10")) {}
                    }
                }
                circle(.r("5"), .clipPath("url(#c)")) {}
            },
            #"<svg><defs><clipPath id="c"><rect width="10" height="10"></rect></clipPath></defs><circle r="5" clip-path="url(#c)"></circle></svg>"#
        )
    }

    // MARK: - Formatted rendering

    @Test func testFormattedShapesRenderInlineWithinContainers() {
        // Containers (svg, g) format as indented blocks; leaf shapes stay inline.
        HTMLFormattedAssertEqual(
            svg(.viewBox("0 0 10 10")) {
                g {
                    rect(.x("0"), .y("0"), .width("5"), .height("5")) {}
                    circle(.cx("5"), .cy("5"), .r("2")) {}
                }
            },
            """
            <svg viewBox="0 0 10 10">
              <g><rect x="0" y="0" width="5" height="5"></rect><circle cx="5" cy="5" r="2"></circle></g>
            </svg>
            """
        )
    }

    @Test func testFormattedTextKeepsContentInline() {
        // <text> is RenderedInline, so its whitespace-significant content stays put
        // even when it trails block siblings (regression for the formatter bug where
        // inline text leaked out of its element).
        HTMLFormattedAssertEqual(
            svg {
                defs {
                    linearGradient(.id("g")) {
                        stop(.offset("0%"), .stopColor("red")) {}
                    }
                }
                text(.x("2"), .y("20")) { "Hi" }
            },
            """
            <svg>
              <defs>
                <linearGradient id="g"><stop offset="0%" stop-color="red"></stop></linearGradient>
              </defs>
              <text x="2" y="20">Hi</text>
            </svg>
            """
        )
    }
}
