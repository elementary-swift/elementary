import Elementary

public extension SVGTag {
    enum svg: SVGTagDefinition, HTMLTagDefinition { public static let name = "svg" }
    enum g: SVGTagDefinition { public static let name = "g" }
    enum defs: SVGTagDefinition { public static let name = "defs" }
    enum symbol: SVGTagDefinition { public static let name = "symbol" }
    enum use: SVGTagDefinition { public static let name = "use" }
    enum path: SVGTagDefinition { public static let name = "path" }
    enum rect: SVGTagDefinition { public static let name = "rect" }
    enum circle: SVGTagDefinition { public static let name = "circle" }
    enum ellipse: SVGTagDefinition { public static let name = "ellipse" }
    enum line: SVGTagDefinition { public static let name = "line" }
    enum polyline: SVGTagDefinition { public static let name = "polyline" }
    enum polygon: SVGTagDefinition { public static let name = "polygon" }
    enum text: SVGTagDefinition { public static let name = "text" }
    enum tspan: SVGTagDefinition, SVGTrait.RenderedInline { public static let name = "tspan" }
    enum title: SVGTagDefinition { public static let name = "title" }
    enum desc: SVGTagDefinition { public static let name = "desc" }
    enum linearGradient: SVGTagDefinition { public static let name = "linearGradient" }
    enum radialGradient: SVGTagDefinition { public static let name = "radialGradient" }
    enum stop: SVGTagDefinition { public static let name = "stop" }
    enum clipPath: SVGTagDefinition { public static let name = "clipPath" }
    enum mask: SVGTagDefinition { public static let name = "mask" }
    enum image: SVGTagDefinition { public static let name = "image" }
    enum marker: SVGTagDefinition { public static let name = "marker" }
    enum pattern: SVGTagDefinition { public static let name = "pattern" }
}

public extension SVG {
    typealias svg<Content: SVGContent> = SVGElement<SVGTag.svg, Content>
    typealias g<Content: SVGContent> = SVGElement<SVGTag.g, Content>
    typealias defs<Content: SVGContent> = SVGElement<SVGTag.defs, Content>
    typealias symbol<Content: SVGContent> = SVGElement<SVGTag.symbol, Content>
    typealias text<Content: SVGContent> = SVGElement<SVGTag.text, Content>
    typealias tspan<Content: SVGContent> = SVGElement<SVGTag.tspan, Content>
    typealias title<Content: SVGContent> = SVGElement<SVGTag.title, Content>
    typealias desc<Content: SVGContent> = SVGElement<SVGTag.desc, Content>
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
