//
//  SVGTags.swift
//  elementary
//
//  Created by Klaus Kneupner on 11/07/2026.
//
// SVG child tag definitions.
//
// The `<svg>` tag itself lives with the other HTML tags in `HtmlTags.swift`
// (it has always been part of the element vocabulary as an HTML container).
// This file adds the SVG-internal vocabulary as regular ``HTMLTag`` definitions.
//
// Leaf shapes and text are `RenderedInline` so the formatter keeps them (and
// their whitespace-significant content) on a single line. Containers such as
// `g`, `defs`, `symbol`, gradients, `pattern` and `filter` format as blocks.

public extension HTMLTag {
    // Root / containers
    enum svg: HTMLTrait.Paired { public static let name = "svg" }
    enum g: HTMLTrait.Paired { public static let name = "g" }
    enum defs: HTMLTrait.Paired { public static let name = "defs" }
    enum symbol: HTMLTrait.Paired { public static let name = "symbol" }
    enum use: HTMLTrait.Paired, HTMLTrait.RenderedInline { public static let name = "use" }

    // Shapes
    enum path: HTMLTrait.Paired, HTMLTrait.RenderedInline { public static let name = "path" }
    enum rect: HTMLTrait.Paired, HTMLTrait.RenderedInline { public static let name = "rect" }
    enum circle: HTMLTrait.Paired, HTMLTrait.RenderedInline { public static let name = "circle" }
    enum ellipse: HTMLTrait.Paired, HTMLTrait.RenderedInline { public static let name = "ellipse" }
    enum line: HTMLTrait.Paired, HTMLTrait.RenderedInline { public static let name = "line" }
    enum polyline: HTMLTrait.Paired, HTMLTrait.RenderedInline { public static let name = "polyline" }
    enum polygon: HTMLTrait.Paired, HTMLTrait.RenderedInline { public static let name = "polygon" }

    // Text
    enum text: HTMLTrait.Paired, HTMLTrait.RenderedInline { public static let name = "text" }

    // Clipping / masking
    enum clipPath: HTMLTrait.Paired { public static let name = "clipPath" }
    enum mask: HTMLTrait.Paired { public static let name = "mask" }

    // Gradients / paint servers
    enum linearGradient: HTMLTrait.Paired { public static let name = "linearGradient" }
    enum radialGradient: HTMLTrait.Paired { public static let name = "radialGradient" }
    enum stop: HTMLTrait.Paired, HTMLTrait.RenderedInline { public static let name = "stop" }
    enum pattern: HTMLTrait.Paired { public static let name = "pattern" }

    // Filters
    enum filter: HTMLTrait.Paired { public static let name = "filter" }
}
