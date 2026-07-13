import Elementary

public enum SVGTrait {
    /// A marker that indicates that an SVG tag should be rendered inline in formatted output.
    public protocol RenderedInline {}

    public enum Attributes {}
}

public extension SVGAttribute where Tag == SVGTag.svg {
    static func xmlns(_ value: String = "http://www.w3.org/2000/svg") -> Self {
        SVGAttribute(name: "xmlns", value: value)
    }
}

public extension SVGTrait.Attributes {
    protocol PreserveAspectRatio {}
    protocol ViewBox: PreserveAspectRatio {}
}

extension SVGTag.svg: SVGTrait.Attributes.ViewBox {}
extension SVGTag.symbol: SVGTrait.Attributes.ViewBox {}
extension SVGTag.marker: SVGTrait.Attributes.ViewBox {}
extension SVGTag.pattern: SVGTrait.Attributes.ViewBox {}
extension SVGTag.image: SVGTrait.Attributes.PreserveAspectRatio {}

public extension SVGAttribute where Tag: SVGTrait.Attributes.PreserveAspectRatio {
    static func preserveAspectRatio(_ value: SVGAttributeValue.PreserveAspectRatio) -> Self {
        SVGAttribute(name: "preserveAspectRatio", value: value.rawValue)
    }
}

public extension SVGAttribute where Tag: SVGTrait.Attributes.ViewBox {
    static func viewBox(_ minX: SVGAttributeValue.Number, _ minY: SVGAttributeValue.Number, _ width: SVGAttributeValue.Number, _ height: SVGAttributeValue.Number) -> Self {
        SVGAttribute(name: "viewBox", value: "\(minX.value) \(minY.value) \(width.value) \(height.value)")
    }
}

public extension SVGTrait.Attributes {
    protocol Sizing {}
}

extension SVGTag.svg: SVGTrait.Attributes.Sizing {}
extension SVGTag.symbol: SVGTrait.Attributes.Sizing {}
extension SVGTag.use: SVGTrait.Attributes.Sizing {}
extension SVGTag.rect: SVGTrait.Attributes.Sizing {}
extension SVGTag.mask: SVGTrait.Attributes.Sizing {}
extension SVGTag.image: SVGTrait.Attributes.Sizing {}
extension SVGTag.pattern: SVGTrait.Attributes.Sizing {}

public extension SVGAttribute where Tag: SVGTrait.Attributes.Sizing {
    static func width(_ value: SVGAttributeValue.Length) -> Self {
        SVGAttribute(name: "width", value: value.value)
    }

    static func height(_ value: SVGAttributeValue.Length) -> Self {
        SVGAttribute(name: "height", value: value.value)
    }
}

public extension SVGTrait.Attributes {
    protocol Position {}
}

extension SVGTag.svg: SVGTrait.Attributes.Position {}
extension SVGTag.symbol: SVGTrait.Attributes.Position {}
extension SVGTag.use: SVGTrait.Attributes.Position {}
extension SVGTag.rect: SVGTrait.Attributes.Position {}
extension SVGTag.text: SVGTrait.Attributes.Position {}
extension SVGTag.tspan: SVGTrait.Attributes.Position {}
extension SVGTag.mask: SVGTrait.Attributes.Position {}
extension SVGTag.image: SVGTrait.Attributes.Position {}
extension SVGTag.pattern: SVGTrait.Attributes.Position {}

public extension SVGAttribute where Tag: SVGTrait.Attributes.Position {
    static func x(_ value: SVGAttributeValue.Length) -> Self {
        SVGAttribute(name: "x", value: value.value)
    }

    static func y(_ value: SVGAttributeValue.Length) -> Self {
        SVGAttribute(name: "y", value: value.value)
    }
}

public extension SVGTrait.Attributes {
    protocol Points {}
}

extension SVGTag.polyline: SVGTrait.Attributes.Points {}
extension SVGTag.polygon: SVGTrait.Attributes.Points {}

public extension SVGAttribute where Tag: SVGTrait.Attributes.Points {
    static func points(_ value: String) -> Self {
        SVGAttribute(name: "points", value: value)
    }
}

public extension SVGTrait.Attributes {
    protocol Presentation {}
}

extension SVGTag.svg: SVGTrait.Attributes.Presentation {}
extension SVGTag.g: SVGTrait.Attributes.Presentation {}
extension SVGTag.symbol: SVGTrait.Attributes.Presentation {}
extension SVGTag.use: SVGTrait.Attributes.Presentation {}
extension SVGTag.path: SVGTrait.Attributes.Presentation {}
extension SVGTag.rect: SVGTrait.Attributes.Presentation {}
extension SVGTag.circle: SVGTrait.Attributes.Presentation {}
extension SVGTag.ellipse: SVGTrait.Attributes.Presentation {}
extension SVGTag.line: SVGTrait.Attributes.Presentation {}
extension SVGTag.polyline: SVGTrait.Attributes.Presentation {}
extension SVGTag.polygon: SVGTrait.Attributes.Presentation {}
extension SVGTag.text: SVGTrait.Attributes.Presentation {}
extension SVGTag.tspan: SVGTrait.Attributes.Presentation {}
extension SVGTag.clipPath: SVGTrait.Attributes.Presentation {}
extension SVGTag.mask: SVGTrait.Attributes.Presentation {}
extension SVGTag.image: SVGTrait.Attributes.Presentation {}
extension SVGTag.marker: SVGTrait.Attributes.Presentation {}
extension SVGTag.pattern: SVGTrait.Attributes.Presentation {}

public extension SVGAttribute where Tag: SVGTrait.Attributes.Presentation {
    static func fill(_ value: SVGAttributeValue.Paint) -> Self {
        SVGAttribute(name: "fill", value: value.value)
    }

    static func fillOpacity(_ value: Double) -> Self {
        SVGAttribute(name: "fill-opacity", value: "\(value)")
    }

    static func fillRule(_ value: SVGAttributeValue.FillRule) -> Self {
        SVGAttribute(name: "fill-rule", value: value.rawValue)
    }

    static func stroke(_ value: SVGAttributeValue.Paint) -> Self {
        SVGAttribute(name: "stroke", value: value.value)
    }

    static func strokeOpacity(_ value: Double) -> Self {
        SVGAttribute(name: "stroke-opacity", value: "\(value)")
    }

    static func strokeWidth(_ value: SVGAttributeValue.Length) -> Self {
        SVGAttribute(name: "stroke-width", value: value.value)
    }

    static func strokeLinecap(_ value: SVGAttributeValue.LineCap) -> Self {
        SVGAttribute(name: "stroke-linecap", value: value.rawValue)
    }

    static func strokeLinejoin(_ value: SVGAttributeValue.LineJoin) -> Self {
        SVGAttribute(name: "stroke-linejoin", value: value.rawValue)
    }

    static func strokeDasharray(_ value: String) -> Self {
        SVGAttribute(name: "stroke-dasharray", value: value)
    }

    static func strokeDashoffset(_ value: SVGAttributeValue.Length) -> Self {
        SVGAttribute(name: "stroke-dashoffset", value: value.value)
    }

    static func strokeMiterlimit(_ value: SVGAttributeValue.Number) -> Self {
        SVGAttribute(name: "stroke-miterlimit", value: value.value)
    }

    static func opacity(_ value: Double) -> Self {
        SVGAttribute(name: "opacity", value: "\(value)")
    }

    static func transform(_ value: String) -> Self {
        SVGAttribute(name: "transform", value: value)
    }

    static func color(_ value: SVGAttributeValue.Paint) -> Self {
        SVGAttribute(name: "color", value: value.value)
    }

    static func clipRule(_ value: SVGAttributeValue.FillRule) -> Self {
        SVGAttribute(name: "clip-rule", value: value.rawValue)
    }

    static func clipPath(_ value: String) -> Self {
        SVGAttribute(name: "clip-path", value: value)
    }

    static func mask(_ value: String) -> Self {
        SVGAttribute(name: "mask", value: value)
    }
}

public extension SVGTrait.Attributes {
    protocol TextPresentation {}
}

extension SVGTag.text: SVGTrait.Attributes.TextPresentation {}
extension SVGTag.tspan: SVGTrait.Attributes.TextPresentation {}

public extension SVGAttribute where Tag: SVGTrait.Attributes.TextPresentation {
    static func fontFamily(_ value: String) -> Self {
        SVGAttribute(name: "font-family", value: value)
    }

    static func fontSize(_ value: SVGAttributeValue.Length) -> Self {
        SVGAttribute(name: "font-size", value: value.value)
    }

    static func fontWeight(_ value: String) -> Self {
        SVGAttribute(name: "font-weight", value: value)
    }

    static func fontStyle(_ value: String) -> Self {
        SVGAttribute(name: "font-style", value: value)
    }

    static func fontVariant(_ value: String) -> Self {
        SVGAttribute(name: "font-variant", value: value)
    }

    static func letterSpacing(_ value: SVGAttributeValue.Length) -> Self {
        SVGAttribute(name: "letter-spacing", value: value.value)
    }

    static func wordSpacing(_ value: SVGAttributeValue.Length) -> Self {
        SVGAttribute(name: "word-spacing", value: value.value)
    }

    static func textDecoration(_ value: String) -> Self {
        SVGAttribute(name: "text-decoration", value: value)
    }

    static func textAnchor(_ value: String) -> Self {
        SVGAttribute(name: "text-anchor", value: value)
    }

    static func dominantBaseline(_ value: String) -> Self {
        SVGAttribute(name: "dominant-baseline", value: value)
    }
}

public extension SVGTrait.Attributes {
    protocol Gradient {}
}

extension SVGTag.linearGradient: SVGTrait.Attributes.Gradient {}
extension SVGTag.radialGradient: SVGTrait.Attributes.Gradient {}

public extension SVGAttribute where Tag: SVGTrait.Attributes.Gradient {
    static func gradientUnits(_ value: SVGAttributeValue.CoordinateSystem) -> Self {
        SVGAttribute(name: "gradientUnits", value: value.rawValue)
    }

    static func gradientTransform(_ value: String) -> Self {
        SVGAttribute(name: "gradientTransform", value: value)
    }

    static func spreadMethod(_ value: SVGAttributeValue.SpreadMethod) -> Self {
        SVGAttribute(name: "spreadMethod", value: value.rawValue)
    }
}

public extension SVGAttribute where Tag == SVGTag.path {
    static func d(_ value: String) -> Self {
        SVGAttribute(name: "d", value: value)
    }
}

public extension SVGAttribute where Tag == SVGTag.use {
    static func href(_ value: String) -> Self {
        SVGAttribute(name: "href", value: value)
    }
}

public extension SVGAttribute where Tag == SVGTag.image {
    static func href(_ value: String) -> Self {
        SVGAttribute(name: "href", value: value)
    }
}

public extension SVGAttribute where Tag == SVGTag.rect {
    static func rx(_ value: SVGAttributeValue.Length) -> Self {
        SVGAttribute(name: "rx", value: value.value)
    }

    static func ry(_ value: SVGAttributeValue.Length) -> Self {
        SVGAttribute(name: "ry", value: value.value)
    }
}

public extension SVGAttribute where Tag == SVGTag.circle {
    static func cx(_ value: SVGAttributeValue.Length) -> Self {
        SVGAttribute(name: "cx", value: value.value)
    }

    static func cy(_ value: SVGAttributeValue.Length) -> Self {
        SVGAttribute(name: "cy", value: value.value)
    }

    static func r(_ value: SVGAttributeValue.Length) -> Self {
        SVGAttribute(name: "r", value: value.value)
    }
}

public extension SVGAttribute where Tag == SVGTag.ellipse {
    static func cx(_ value: SVGAttributeValue.Length) -> Self {
        SVGAttribute(name: "cx", value: value.value)
    }

    static func cy(_ value: SVGAttributeValue.Length) -> Self {
        SVGAttribute(name: "cy", value: value.value)
    }

    static func rx(_ value: SVGAttributeValue.Length) -> Self {
        SVGAttribute(name: "rx", value: value.value)
    }

    static func ry(_ value: SVGAttributeValue.Length) -> Self {
        SVGAttribute(name: "ry", value: value.value)
    }
}

public extension SVGAttribute where Tag == SVGTag.line {
    static func x1(_ value: SVGAttributeValue.Length) -> Self {
        SVGAttribute(name: "x1", value: value.value)
    }

    static func y1(_ value: SVGAttributeValue.Length) -> Self {
        SVGAttribute(name: "y1", value: value.value)
    }

    static func x2(_ value: SVGAttributeValue.Length) -> Self {
        SVGAttribute(name: "x2", value: value.value)
    }

    static func y2(_ value: SVGAttributeValue.Length) -> Self {
        SVGAttribute(name: "y2", value: value.value)
    }
}

public extension SVGAttribute where Tag == SVGTag.linearGradient {
    static func x1(_ value: SVGAttributeValue.Length) -> Self {
        SVGAttribute(name: "x1", value: value.value)
    }

    static func y1(_ value: SVGAttributeValue.Length) -> Self {
        SVGAttribute(name: "y1", value: value.value)
    }

    static func x2(_ value: SVGAttributeValue.Length) -> Self {
        SVGAttribute(name: "x2", value: value.value)
    }

    static func y2(_ value: SVGAttributeValue.Length) -> Self {
        SVGAttribute(name: "y2", value: value.value)
    }
}

public extension SVGAttribute where Tag == SVGTag.radialGradient {
    static func cx(_ value: SVGAttributeValue.Length) -> Self {
        SVGAttribute(name: "cx", value: value.value)
    }

    static func cy(_ value: SVGAttributeValue.Length) -> Self {
        SVGAttribute(name: "cy", value: value.value)
    }

    static func r(_ value: SVGAttributeValue.Length) -> Self {
        SVGAttribute(name: "r", value: value.value)
    }

    static func fx(_ value: SVGAttributeValue.Length) -> Self {
        SVGAttribute(name: "fx", value: value.value)
    }

    static func fy(_ value: SVGAttributeValue.Length) -> Self {
        SVGAttribute(name: "fy", value: value.value)
    }

    static func fr(_ value: SVGAttributeValue.Length) -> Self {
        SVGAttribute(name: "fr", value: value.value)
    }
}

public extension SVGAttribute where Tag == SVGTag.marker {
    static func markerWidth(_ value: SVGAttributeValue.Length) -> Self {
        SVGAttribute(name: "markerWidth", value: value.value)
    }

    static func markerHeight(_ value: SVGAttributeValue.Length) -> Self {
        SVGAttribute(name: "markerHeight", value: value.value)
    }

    static func markerUnits(_ value: SVGAttributeValue.MarkerUnits) -> Self {
        SVGAttribute(name: "markerUnits", value: value.rawValue)
    }

    static func refX(_ value: SVGAttributeValue.Length) -> Self {
        SVGAttribute(name: "refX", value: value.value)
    }

    static func refY(_ value: SVGAttributeValue.Length) -> Self {
        SVGAttribute(name: "refY", value: value.value)
    }

    static func orient(_ value: SVGAttributeValue.Orient) -> Self {
        SVGAttribute(name: "orient", value: value.rawValue)
    }
}

public extension SVGAttribute where Tag == SVGTag.pattern {
    static func patternUnits(_ value: SVGAttributeValue.CoordinateSystem) -> Self {
        SVGAttribute(name: "patternUnits", value: value.rawValue)
    }

    static func patternContentUnits(_ value: SVGAttributeValue.CoordinateSystem) -> Self {
        SVGAttribute(name: "patternContentUnits", value: value.rawValue)
    }

    static func patternTransform(_ value: String) -> Self {
        SVGAttribute(name: "patternTransform", value: value)
    }
}

public extension SVGAttribute where Tag == SVGTag.stop {
    static func offset(_ value: SVGAttributeValue.Length) -> Self {
        SVGAttribute(name: "offset", value: value.value)
    }

    static func stopColor(_ value: SVGAttributeValue.Paint) -> Self {
        SVGAttribute(name: "stop-color", value: value.value)
    }

    static func stopOpacity(_ value: Double) -> Self {
        SVGAttribute(name: "stop-opacity", value: "\(value)")
    }
}

public extension SVGAttribute where Tag == SVGTag.clipPath {
    static func clipPathUnits(_ value: SVGAttributeValue.CoordinateSystem) -> Self {
        SVGAttribute(name: "clipPathUnits", value: value.rawValue)
    }
}

public extension SVGAttribute where Tag == SVGTag.mask {
    static func maskType(_ value: SVGAttributeValue.MaskType) -> Self {
        SVGAttribute(name: "mask-type", value: value.rawValue)
    }

    static func maskUnits(_ value: SVGAttributeValue.CoordinateSystem) -> Self {
        SVGAttribute(name: "maskUnits", value: value.rawValue)
    }

    static func maskContentUnits(_ value: SVGAttributeValue.CoordinateSystem) -> Self {
        SVGAttribute(name: "maskContentUnits", value: value.rawValue)
    }
}
