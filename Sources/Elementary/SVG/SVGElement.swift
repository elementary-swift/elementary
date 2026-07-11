//
//  SVGElement.swift
//  elementary
//
//  Created by Klaus Kneupner on 11/07/2026.
//
// SVG elements are modeled as regular ``HTMLElement`` values, exactly like HTML
// tags. Elementary does not enforce HTML containment rules (any HTML can nest in
// any HTML), so SVG follows the same convention: an `<svg>` can appear wherever
// HTML content is expected, and SVG children nest freely inside it.
//
// The tag definitions live in `SVGTags.swift` and the attributes in
// `SVGAttributes.swift`.
//
// Note: SVG has no "void elements" in the HTML sense. In HTML5, SVG is parsed as
// foreign content where an unclosed `<circle>` would swallow following siblings.
// Modeling every SVG element as paired (`<circle></circle>`) is therefore always
// valid, so all of these are `HTMLElement`, never `HTMLVoidElement`.

// Root / containers
public typealias svg<Content: HTML> = HTMLElement<HTMLTag.svg, Content>
public typealias g<Content: HTML> = HTMLElement<HTMLTag.g, Content>
public typealias defs<Content: HTML> = HTMLElement<HTMLTag.defs, Content>
public typealias symbol<Content: HTML> = HTMLElement<HTMLTag.symbol, Content>
public typealias use<Content: HTML> = HTMLElement<HTMLTag.use, Content>

// Shapes
public typealias path<Content: HTML> = HTMLElement<HTMLTag.path, Content>
public typealias rect<Content: HTML> = HTMLElement<HTMLTag.rect, Content>
public typealias circle<Content: HTML> = HTMLElement<HTMLTag.circle, Content>
public typealias ellipse<Content: HTML> = HTMLElement<HTMLTag.ellipse, Content>
public typealias line<Content: HTML> = HTMLElement<HTMLTag.line, Content>
public typealias polyline<Content: HTML> = HTMLElement<HTMLTag.polyline, Content>
public typealias polygon<Content: HTML> = HTMLElement<HTMLTag.polygon, Content>

// Text
public typealias text<Content: HTML> = HTMLElement<HTMLTag.text, Content>

// Clipping / masking
public typealias clipPath<Content: HTML> = HTMLElement<HTMLTag.clipPath, Content>
public typealias mask<Content: HTML> = HTMLElement<HTMLTag.mask, Content>

// Gradients / paint servers
public typealias linearGradient<Content: HTML> = HTMLElement<HTMLTag.linearGradient, Content>
public typealias radialGradient<Content: HTML> = HTMLElement<HTMLTag.radialGradient, Content>
public typealias stop<Content: HTML> = HTMLElement<HTMLTag.stop, Content>
public typealias pattern<Content: HTML> = HTMLElement<HTMLTag.pattern, Content>

// Filters
public typealias filter<Content: HTML> = HTMLElement<HTMLTag.filter, Content>
