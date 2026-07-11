//
//  SVGAttributes.swift
//  elementary
//
//  Created by Klaus Kneupner on 11/07/2026.
//
// SVG-specific attributes.
//
// These extend the shared attribute machinery from `HtmlAttributes+common.swift`
// (e.g. the `href` and `dimensions` traits) and add SVG-only attributes, keeping
// all SVG vocabulary in the SVG folder.

// MARK: - Reuse of shared HTML attribute traits

// <use href="#id"> reuses the shared `href` helper.
extension HTMLTag.use: HTMLTrait.Attributes.href {}
// <svg width height> reuses the shared integer `dimensions` helpers.
extension HTMLTag.svg: HTMLTrait.Attributes.dimensions {}

// MARK: - <svg>

public extension HTMLAttribute where Tag == HTMLTag.svg {
    /// Explicit XML namespace for standalone SVGs (optional in HTML inline SVG).
    static func xmlns(_ uri: String = "http://www.w3.org/2000/svg") -> Self {
        HTMLAttribute(name: "xmlns", value: uri)
    }

    /// Optional XLink namespace for legacy xlink:* usage.
    static func xmlnsXLink(_ uri: String = "http://www.w3.org/1999/xlink") -> Self {
        HTMLAttribute(name: "xmlns:xlink", value: uri)
    }

    static func viewBox(_ value: String) -> Self { HTMLAttribute(name: "viewBox", value: value) }
    static func preserveAspectRatio(_ value: String) -> Self { HTMLAttribute(name: "preserveAspectRatio", value: value) }
}

// MARK: - Shared presentation attributes (paint, opacity, stroke styling, references)

public extension HTMLTrait.Attributes { protocol svgPresentation {} }

extension HTMLTag.svg: HTMLTrait.Attributes.svgPresentation {}
extension HTMLTag.path: HTMLTrait.Attributes.svgPresentation {}
extension HTMLTag.rect: HTMLTrait.Attributes.svgPresentation {}
extension HTMLTag.circle: HTMLTrait.Attributes.svgPresentation {}
extension HTMLTag.ellipse: HTMLTrait.Attributes.svgPresentation {}
extension HTMLTag.line: HTMLTrait.Attributes.svgPresentation {}
extension HTMLTag.polyline: HTMLTrait.Attributes.svgPresentation {}
extension HTMLTag.polygon: HTMLTrait.Attributes.svgPresentation {}
extension HTMLTag.g: HTMLTrait.Attributes.svgPresentation {}
extension HTMLTag.text: HTMLTrait.Attributes.svgPresentation {}
extension HTMLTag.use: HTMLTrait.Attributes.svgPresentation {}

public extension HTMLAttribute where Tag: HTMLTrait.Attributes.svgPresentation {
    static func fill(_ value: String) -> Self { HTMLAttribute(name: "fill", value: value) }
    static func stroke(_ value: String) -> Self { HTMLAttribute(name: "stroke", value: value) }
    static func strokeWidth(_ value: String) -> Self { HTMLAttribute(name: "stroke-width", value: value) }
    static func transform(_ value: String) -> Self { HTMLAttribute(name: "transform", value: value) }
    static func opacity(_ value: String) -> Self { HTMLAttribute(name: "opacity", value: value) }
    static func fillOpacity(_ value: String) -> Self { HTMLAttribute(name: "fill-opacity", value: value) }
    static func fillRule(_ value: String) -> Self { HTMLAttribute(name: "fill-rule", value: value) }
    static func strokeOpacity(_ value: String) -> Self { HTMLAttribute(name: "stroke-opacity", value: value) }
    static func strokeLinecap(_ value: String) -> Self { HTMLAttribute(name: "stroke-linecap", value: value) }
    static func strokeLinejoin(_ value: String) -> Self { HTMLAttribute(name: "stroke-linejoin", value: value) }
    static func strokeMiterlimit(_ value: String) -> Self { HTMLAttribute(name: "stroke-miterlimit", value: value) }
    static func strokeDasharray(_ value: String) -> Self { HTMLAttribute(name: "stroke-dasharray", value: value) }
    static func strokeDashoffset(_ value: String) -> Self { HTMLAttribute(name: "stroke-dashoffset", value: value) }
    static func clipRule(_ value: String) -> Self { HTMLAttribute(name: "clip-rule", value: value) }
    static func color(_ value: String) -> Self { HTMLAttribute(name: "color", value: value) }
    static func vectorEffect(_ value: String) -> Self { HTMLAttribute(name: "vector-effect", value: value) }
    /// References a paint server, clip path, mask or filter, e.g. `.clipPath("url(#c)")`.
    static func clipPath(_ value: String) -> Self { HTMLAttribute(name: "clip-path", value: value) }
    static func mask(_ value: String) -> Self { HTMLAttribute(name: "mask", value: value) }
    static func filter(_ value: String) -> Self { HTMLAttribute(name: "filter", value: value) }
}

// MARK: - <path>

public extension HTMLAttribute where Tag == HTMLTag.path {
    static func d(_ value: String) -> Self { HTMLAttribute(name: "d", value: value) }
    static func pathLength(_ value: String) -> Self { HTMLAttribute(name: "pathLength", value: value) }
}

// MARK: - Shapes

public extension HTMLAttribute where Tag == HTMLTag.circle {
    static func cx(_ value: String) -> Self { HTMLAttribute(name: "cx", value: value) }
    static func cy(_ value: String) -> Self { HTMLAttribute(name: "cy", value: value) }
    static func r(_ value: String) -> Self { HTMLAttribute(name: "r", value: value) }
}

public extension HTMLAttribute where Tag == HTMLTag.ellipse {
    static func cx(_ value: String) -> Self { HTMLAttribute(name: "cx", value: value) }
    static func cy(_ value: String) -> Self { HTMLAttribute(name: "cy", value: value) }
    static func rx(_ value: String) -> Self { HTMLAttribute(name: "rx", value: value) }
    static func ry(_ value: String) -> Self { HTMLAttribute(name: "ry", value: value) }
}

public extension HTMLAttribute where Tag == HTMLTag.rect {
    static func x(_ value: String) -> Self { HTMLAttribute(name: "x", value: value) }
    static func y(_ value: String) -> Self { HTMLAttribute(name: "y", value: value) }
    static func width(_ value: String) -> Self { HTMLAttribute(name: "width", value: value) }
    static func height(_ value: String) -> Self { HTMLAttribute(name: "height", value: value) }
    static func rx(_ value: String) -> Self { HTMLAttribute(name: "rx", value: value) }
    static func ry(_ value: String) -> Self { HTMLAttribute(name: "ry", value: value) }
}

public extension HTMLAttribute where Tag == HTMLTag.line {
    static func x1(_ value: String) -> Self { HTMLAttribute(name: "x1", value: value) }
    static func y1(_ value: String) -> Self { HTMLAttribute(name: "y1", value: value) }
    static func x2(_ value: String) -> Self { HTMLAttribute(name: "x2", value: value) }
    static func y2(_ value: String) -> Self { HTMLAttribute(name: "y2", value: value) }
}

public extension HTMLAttribute where Tag == HTMLTag.polyline {
    static func points(_ value: String) -> Self { HTMLAttribute(name: "points", value: value) }
}

public extension HTMLAttribute where Tag == HTMLTag.polygon {
    static func points(_ value: String) -> Self { HTMLAttribute(name: "points", value: value) }
}

// MARK: - <text> typography and positioning

public extension HTMLAttribute where Tag == HTMLTag.text {
    static func x(_ value: String) -> Self { HTMLAttribute(name: "x", value: value) }
    static func y(_ value: String) -> Self { HTMLAttribute(name: "y", value: value) }
    static func dx(_ value: String) -> Self { HTMLAttribute(name: "dx", value: value) }
    static func dy(_ value: String) -> Self { HTMLAttribute(name: "dy", value: value) }
    static func textAnchor(_ value: String) -> Self { HTMLAttribute(name: "text-anchor", value: value) }
    static func dominantBaseline(_ value: String) -> Self { HTMLAttribute(name: "dominant-baseline", value: value) }
    static func fontFamily(_ value: String) -> Self { HTMLAttribute(name: "font-family", value: value) }
    static func fontSize(_ value: String) -> Self { HTMLAttribute(name: "font-size", value: value) }
    static func fontWeight(_ value: String) -> Self { HTMLAttribute(name: "font-weight", value: value) }
    static func fontStyle(_ value: String) -> Self { HTMLAttribute(name: "font-style", value: value) }
    static func letterSpacing(_ value: String) -> Self { HTMLAttribute(name: "letter-spacing", value: value) }
    static func textDecoration(_ value: String) -> Self { HTMLAttribute(name: "text-decoration", value: value) }
}

// MARK: - <use>

public extension HTMLAttribute where Tag == HTMLTag.use {
    /// XLink href helper for legacy content; prefer plain `href` on `<use>` when possible.
    static func xlinkHref(_ value: String) -> Self { HTMLAttribute(name: "xlink:href", value: value) }
    static func x(_ value: String) -> Self { HTMLAttribute(name: "x", value: value) }
    static func y(_ value: String) -> Self { HTMLAttribute(name: "y", value: value) }
    static func width(_ value: String) -> Self { HTMLAttribute(name: "width", value: value) }
    static func height(_ value: String) -> Self { HTMLAttribute(name: "height", value: value) }
}

// MARK: - <symbol>

public extension HTMLAttribute where Tag == HTMLTag.symbol {
    static func viewBox(_ value: String) -> Self { HTMLAttribute(name: "viewBox", value: value) }
    static func preserveAspectRatio(_ value: String) -> Self { HTMLAttribute(name: "preserveAspectRatio", value: value) }
}

// MARK: - Gradients

public extension HTMLAttribute where Tag == HTMLTag.linearGradient {
    static func x1(_ value: String) -> Self { HTMLAttribute(name: "x1", value: value) }
    static func y1(_ value: String) -> Self { HTMLAttribute(name: "y1", value: value) }
    static func x2(_ value: String) -> Self { HTMLAttribute(name: "x2", value: value) }
    static func y2(_ value: String) -> Self { HTMLAttribute(name: "y2", value: value) }
    static func gradientUnits(_ value: String) -> Self { HTMLAttribute(name: "gradientUnits", value: value) }
    static func gradientTransform(_ value: String) -> Self { HTMLAttribute(name: "gradientTransform", value: value) }
    static func spreadMethod(_ value: String) -> Self { HTMLAttribute(name: "spreadMethod", value: value) }
}

public extension HTMLAttribute where Tag == HTMLTag.radialGradient {
    static func cx(_ value: String) -> Self { HTMLAttribute(name: "cx", value: value) }
    static func cy(_ value: String) -> Self { HTMLAttribute(name: "cy", value: value) }
    static func r(_ value: String) -> Self { HTMLAttribute(name: "r", value: value) }
    static func fx(_ value: String) -> Self { HTMLAttribute(name: "fx", value: value) }
    static func fy(_ value: String) -> Self { HTMLAttribute(name: "fy", value: value) }
    static func fr(_ value: String) -> Self { HTMLAttribute(name: "fr", value: value) }
    static func gradientUnits(_ value: String) -> Self { HTMLAttribute(name: "gradientUnits", value: value) }
    static func gradientTransform(_ value: String) -> Self { HTMLAttribute(name: "gradientTransform", value: value) }
    static func spreadMethod(_ value: String) -> Self { HTMLAttribute(name: "spreadMethod", value: value) }
}

public extension HTMLAttribute where Tag == HTMLTag.stop {
    static func offset(_ value: String) -> Self { HTMLAttribute(name: "offset", value: value) }
    static func stopColor(_ value: String) -> Self { HTMLAttribute(name: "stop-color", value: value) }
    static func stopOpacity(_ value: String) -> Self { HTMLAttribute(name: "stop-opacity", value: value) }
}

// MARK: - <pattern>

public extension HTMLAttribute where Tag == HTMLTag.pattern {
    static func x(_ value: String) -> Self { HTMLAttribute(name: "x", value: value) }
    static func y(_ value: String) -> Self { HTMLAttribute(name: "y", value: value) }
    static func width(_ value: String) -> Self { HTMLAttribute(name: "width", value: value) }
    static func height(_ value: String) -> Self { HTMLAttribute(name: "height", value: value) }
    static func viewBox(_ value: String) -> Self { HTMLAttribute(name: "viewBox", value: value) }
    static func patternUnits(_ value: String) -> Self { HTMLAttribute(name: "patternUnits", value: value) }
    static func patternContentUnits(_ value: String) -> Self { HTMLAttribute(name: "patternContentUnits", value: value) }
    static func patternTransform(_ value: String) -> Self { HTMLAttribute(name: "patternTransform", value: value) }
}

// MARK: - <filter>

public extension HTMLAttribute where Tag == HTMLTag.filter {
    static func x(_ value: String) -> Self { HTMLAttribute(name: "x", value: value) }
    static func y(_ value: String) -> Self { HTMLAttribute(name: "y", value: value) }
    static func width(_ value: String) -> Self { HTMLAttribute(name: "width", value: value) }
    static func height(_ value: String) -> Self { HTMLAttribute(name: "height", value: value) }
    static func filterUnits(_ value: String) -> Self { HTMLAttribute(name: "filterUnits", value: value) }
    static func primitiveUnits(_ value: String) -> Self { HTMLAttribute(name: "primitiveUnits", value: value) }
}

// MARK: - <clipPath> / <mask>

public extension HTMLAttribute where Tag == HTMLTag.clipPath {
    static func clipPathUnits(_ value: String) -> Self { HTMLAttribute(name: "clipPathUnits", value: value) }
}

public extension HTMLAttribute where Tag == HTMLTag.mask {
    static func x(_ value: String) -> Self { HTMLAttribute(name: "x", value: value) }
    static func y(_ value: String) -> Self { HTMLAttribute(name: "y", value: value) }
    static func width(_ value: String) -> Self { HTMLAttribute(name: "width", value: value) }
    static func height(_ value: String) -> Self { HTMLAttribute(name: "height", value: value) }
    static func maskUnits(_ value: String) -> Self { HTMLAttribute(name: "maskUnits", value: value) }
    static func maskContentUnits(_ value: String) -> Self { HTMLAttribute(name: "maskContentUnits", value: value) }
}
