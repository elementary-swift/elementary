public extension SVGTag {
    enum svg: SVGTagDefinition, MarkupTrait.AllowsAttributes, HTMLTagDefinition { public static let name = "svg" }
    enum g: SVGTagDefinition, MarkupTrait.AllowsAttributes { public static let name = "g" }
    enum defs: SVGTagDefinition, MarkupTrait.AllowsAttributes { public static let name = "defs" }
    enum symbol: SVGTagDefinition, MarkupTrait.AllowsAttributes { public static let name = "symbol" }
    enum use: SVGTagDefinition, MarkupTrait.AllowsAttributes { public static let name = "use" }
    enum a: SVGTagDefinition, MarkupTrait.AllowsAttributes, SVGTrait.RenderedInline { public static let name = "a" }
    enum path: SVGTagDefinition, MarkupTrait.AllowsAttributes { public static let name = "path" }
    enum rect: SVGTagDefinition, MarkupTrait.AllowsAttributes { public static let name = "rect" }
    enum circle: SVGTagDefinition, MarkupTrait.AllowsAttributes { public static let name = "circle" }
    enum ellipse: SVGTagDefinition, MarkupTrait.AllowsAttributes { public static let name = "ellipse" }
    enum line: SVGTagDefinition, MarkupTrait.AllowsAttributes { public static let name = "line" }
    enum polyline: SVGTagDefinition, MarkupTrait.AllowsAttributes { public static let name = "polyline" }
    enum polygon: SVGTagDefinition, MarkupTrait.AllowsAttributes { public static let name = "polygon" }
    enum text: SVGTagDefinition, MarkupTrait.AllowsAttributes { public static let name = "text" }
    enum tspan: SVGTagDefinition, MarkupTrait.AllowsAttributes, SVGTrait.RenderedInline { public static let name = "tspan" }
    enum textPath: SVGTagDefinition, MarkupTrait.AllowsAttributes, SVGTrait.RenderedInline { public static let name = "textPath" }
    enum title: SVGTagDefinition, MarkupTrait.AllowsAttributes { public static let name = "title" }
    enum desc: SVGTagDefinition, MarkupTrait.AllowsAttributes { public static let name = "desc" }
    enum style: SVGTagDefinition, MarkupTrait.AllowsAttributes { public static let name = "style" }
    enum linearGradient: SVGTagDefinition, MarkupTrait.AllowsAttributes { public static let name = "linearGradient" }
    enum radialGradient: SVGTagDefinition, MarkupTrait.AllowsAttributes { public static let name = "radialGradient" }
    enum stop: SVGTagDefinition, MarkupTrait.AllowsAttributes { public static let name = "stop" }
    enum clipPath: SVGTagDefinition, MarkupTrait.AllowsAttributes { public static let name = "clipPath" }
    enum mask: SVGTagDefinition, MarkupTrait.AllowsAttributes { public static let name = "mask" }
    enum image: SVGTagDefinition, MarkupTrait.AllowsAttributes { public static let name = "image" }
    enum marker: SVGTagDefinition, MarkupTrait.AllowsAttributes { public static let name = "marker" }
    enum pattern: SVGTagDefinition, MarkupTrait.AllowsAttributes { public static let name = "pattern" }
}

public extension SVG {
    typealias svg<Content: SVGContent> = SVGElement<SVGTag.svg, Content>
    typealias g<Content: SVGContent> = SVGElement<SVGTag.g, Content>
    typealias defs<Content: SVGContent> = SVGElement<SVGTag.defs, Content>
    typealias symbol<Content: SVGContent> = SVGElement<SVGTag.symbol, Content>
    typealias a<Content: SVGContent> = SVGElement<SVGTag.a, Content>
    typealias text<Content: SVGContent> = SVGElement<SVGTag.text, Content>
    typealias tspan<Content: SVGContent> = SVGElement<SVGTag.tspan, Content>
    typealias textPath<Content: SVGContent> = SVGElement<SVGTag.textPath, Content>
    typealias title<Content: SVGContent> = SVGElement<SVGTag.title, Content>
    typealias desc<Content: SVGContent> = SVGElement<SVGTag.desc, Content>
    typealias style<Content: SVGContent> = SVGElement<SVGTag.style, Content>
    typealias linearGradient<Content: SVGContent> = SVGElement<SVGTag.linearGradient, Content>
    typealias radialGradient<Content: SVGContent> = SVGElement<SVGTag.radialGradient, Content>
    typealias clipPath<Content: SVGContent> = SVGElement<SVGTag.clipPath, Content>
    typealias mask<Content: SVGContent> = SVGElement<SVGTag.mask, Content>
    typealias marker<Content: SVGContent> = SVGElement<SVGTag.marker, Content>
    typealias pattern<Content: SVGContent> = SVGElement<SVGTag.pattern, Content>

    typealias use<Content: SVGContent> = SVGElement<SVGTag.use, Content>
    typealias path<Content: SVGContent> = SVGElement<SVGTag.path, Content>
    typealias rect<Content: SVGContent> = SVGElement<SVGTag.rect, Content>
    typealias circle<Content: SVGContent> = SVGElement<SVGTag.circle, Content>
    typealias ellipse<Content: SVGContent> = SVGElement<SVGTag.ellipse, Content>
    typealias line<Content: SVGContent> = SVGElement<SVGTag.line, Content>
    typealias polyline<Content: SVGContent> = SVGElement<SVGTag.polyline, Content>
    typealias polygon<Content: SVGContent> = SVGElement<SVGTag.polygon, Content>
    typealias stop<Content: SVGContent> = SVGElement<SVGTag.stop, Content>
    typealias image<Content: SVGContent> = SVGElement<SVGTag.image, Content>
}
