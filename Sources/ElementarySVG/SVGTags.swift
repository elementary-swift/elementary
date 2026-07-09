import Elementary

public enum SVG {}

public enum SVGTag {}

public enum SVGTrait {
    public enum Attributes {}
}

public extension SVGTrait.Attributes {
    protocol Global {}
    protocol Root {}
    protocol ViewBox {}
    protocol Sizing {}
    protocol Position {}
    protocol PathData {}
    protocol RectangleGeometry {}
    protocol CircleGeometry {}
    protocol EllipseGeometry {}
    protocol LineGeometry {}
    protocol Points {}
    protocol Presentation {}
    protocol TextPresentation {}
    protocol Gradient {}
    protocol GradientStop {}
}

public extension SVGTag {
    enum svg: SVGTagDefinition, HTMLTagDefinition, SVGTrait.Attributes.Global, SVGTrait.Attributes.Root, SVGTrait.Attributes.ViewBox,
        SVGTrait.Attributes.Sizing, SVGTrait.Attributes.Presentation
    {
        public static let name = "svg"
    }

    enum g: SVGTagDefinition, SVGTrait.Attributes.Global, SVGTrait.Attributes.Presentation {
        public static let name = "g"
    }

    enum defs: SVGTagDefinition, SVGTrait.Attributes.Global {
        public static let name = "defs"
    }

    enum symbol: SVGTagDefinition, SVGTrait.Attributes.Global, SVGTrait.Attributes.ViewBox, SVGTrait.Attributes.Presentation {
        public static let name = "symbol"
    }

    enum use: SVGTagDefinition, SVGTrait.Attributes.Global, SVGTrait.Attributes.Position, SVGTrait.Attributes.Sizing, SVGTrait.Attributes
            .Presentation
    {
        public static let name = "use"
    }

    enum path: SVGTagDefinition, SVGTrait.Attributes.Global, SVGTrait.Attributes.PathData, SVGTrait.Attributes.Presentation {
        public static let name = "path"
    }

    enum rect: SVGTagDefinition, SVGTrait.Attributes.Global, SVGTrait.Attributes.Position, SVGTrait.Attributes.Sizing, SVGTrait.Attributes
            .RectangleGeometry, SVGTrait.Attributes.Presentation
    {
        public static let name = "rect"
    }

    enum circle: SVGTagDefinition, SVGTrait.Attributes.Global, SVGTrait.Attributes.CircleGeometry, SVGTrait.Attributes.Presentation {
        public static let name = "circle"
    }

    enum ellipse: SVGTagDefinition, SVGTrait.Attributes.Global, SVGTrait.Attributes.EllipseGeometry, SVGTrait.Attributes.Presentation {
        public static let name = "ellipse"
    }

    enum line: SVGTagDefinition, SVGTrait.Attributes.Global, SVGTrait.Attributes.LineGeometry, SVGTrait.Attributes.Presentation {
        public static let name = "line"
    }

    enum polyline: SVGTagDefinition, SVGTrait.Attributes.Global, SVGTrait.Attributes.Points, SVGTrait.Attributes.Presentation {
        public static let name = "polyline"
    }

    enum polygon: SVGTagDefinition, SVGTrait.Attributes.Global, SVGTrait.Attributes.Points, SVGTrait.Attributes.Presentation {
        public static let name = "polygon"
    }

    enum text: SVGTagDefinition, SVGTrait.Attributes.Global, SVGTrait.Attributes.Position, SVGTrait.Attributes.Presentation, SVGTrait
            .Attributes.TextPresentation
    {
        public static let name = "text"
    }

    enum tspan: SVGTagDefinition, SVGTrait.Attributes.Global, SVGTrait.Attributes.Position, SVGTrait.Attributes.Presentation, SVGTrait
            .Attributes.TextPresentation
    {
        public static let name = "tspan"
    }

    enum title: SVGTagDefinition, SVGTrait.Attributes.Global {
        public static let name = "title"
    }

    enum desc: SVGTagDefinition, SVGTrait.Attributes.Global {
        public static let name = "desc"
    }

    enum linearGradient: SVGTagDefinition, SVGTrait.Attributes.Global, SVGTrait.Attributes.Gradient {
        public static let name = "linearGradient"
    }

    enum radialGradient: SVGTagDefinition, SVGTrait.Attributes.Global, SVGTrait.Attributes.Gradient {
        public static let name = "radialGradient"
    }

    enum stop: SVGTagDefinition, SVGTrait.Attributes.Global, SVGTrait.Attributes.GradientStop {
        public static let name = "stop"
    }

    enum clipPath: SVGTagDefinition, SVGTrait.Attributes.Global {
        public static let name = "clipPath"
    }

    enum mask: SVGTagDefinition, SVGTrait.Attributes.Global, SVGTrait.Attributes.Position, SVGTrait.Attributes.Sizing, SVGTrait.Attributes
            .Presentation
    {
        public static let name = "mask"
    }
}

public extension SVG {
    typealias svg<Content: SVGContent> = SVGRoot<Content>
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

    typealias use = SVGElement<SVGTag.use, EmptyContent>
    typealias path = SVGElement<SVGTag.path, EmptyContent>
    typealias rect = SVGElement<SVGTag.rect, EmptyContent>
    typealias circle = SVGElement<SVGTag.circle, EmptyContent>
    typealias ellipse = SVGElement<SVGTag.ellipse, EmptyContent>
    typealias line = SVGElement<SVGTag.line, EmptyContent>
    typealias polyline = SVGElement<SVGTag.polyline, EmptyContent>
    typealias polygon = SVGElement<SVGTag.polygon, EmptyContent>
    typealias stop = SVGElement<SVGTag.stop, EmptyContent>
}
