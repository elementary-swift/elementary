import Elementary

public extension SVGAttribute where Tag: SVGTrait.Attributes.Root {
    static func xmlns(_ value: String = "http://www.w3.org/2000/svg") -> Self {
        SVGAttribute(name: "xmlns", value: value)
    }

    static func preserveAspectRatio(_ value: String) -> Self {
        SVGAttribute(name: "preserveAspectRatio", value: value)
    }
}

public extension SVGAttribute where Tag: SVGTrait.Attributes.ViewBox {
    static func viewBox(_ minX: SVGNumber, _ minY: SVGNumber, _ width: SVGNumber, _ height: SVGNumber) -> Self {
        SVGAttribute(name: "viewBox", value: "\(minX.value) \(minY.value) \(width.value) \(height.value)")
    }
}

public extension SVGAttribute where Tag: SVGTrait.Attributes.Sizing {
    static func width(_ value: some SVGLengthConvertible) -> Self {
        SVGAttribute(name: "width", value: value.svgLength.value)
    }

    static func height(_ value: some SVGLengthConvertible) -> Self {
        SVGAttribute(name: "height", value: value.svgLength.value)
    }
}

public extension SVGAttribute where Tag: SVGTrait.Attributes.Position {
    static func x(_ value: some SVGLengthConvertible) -> Self {
        SVGAttribute(name: "x", value: value.svgLength.value)
    }

    static func y(_ value: some SVGLengthConvertible) -> Self {
        SVGAttribute(name: "y", value: value.svgLength.value)
    }
}

public extension SVGAttribute where Tag: SVGTrait.Attributes.PathData {
    static func d(_ value: SVGPathData) -> Self {
        SVGAttribute(name: "d", value: value.value)
    }

    static func d(_ value: String) -> Self {
        SVGAttribute(name: "d", value: value)
    }
}

public extension SVGAttribute where Tag: SVGTrait.Attributes.RectangleGeometry {
    static func rx(_ value: some SVGLengthConvertible) -> Self {
        SVGAttribute(name: "rx", value: value.svgLength.value)
    }

    static func ry(_ value: some SVGLengthConvertible) -> Self {
        SVGAttribute(name: "ry", value: value.svgLength.value)
    }
}

public extension SVGAttribute where Tag: SVGTrait.Attributes.CircleGeometry {
    static func cx(_ value: some SVGLengthConvertible) -> Self {
        SVGAttribute(name: "cx", value: value.svgLength.value)
    }

    static func cy(_ value: some SVGLengthConvertible) -> Self {
        SVGAttribute(name: "cy", value: value.svgLength.value)
    }

    static func r(_ value: some SVGLengthConvertible) -> Self {
        SVGAttribute(name: "r", value: value.svgLength.value)
    }
}

public extension SVGAttribute where Tag: SVGTrait.Attributes.EllipseGeometry {
    static func cx(_ value: some SVGLengthConvertible) -> Self {
        SVGAttribute(name: "cx", value: value.svgLength.value)
    }

    static func cy(_ value: some SVGLengthConvertible) -> Self {
        SVGAttribute(name: "cy", value: value.svgLength.value)
    }

    static func rx(_ value: some SVGLengthConvertible) -> Self {
        SVGAttribute(name: "rx", value: value.svgLength.value)
    }

    static func ry(_ value: some SVGLengthConvertible) -> Self {
        SVGAttribute(name: "ry", value: value.svgLength.value)
    }
}

public extension SVGAttribute where Tag: SVGTrait.Attributes.LineGeometry {
    static func x1(_ value: some SVGLengthConvertible) -> Self {
        SVGAttribute(name: "x1", value: value.svgLength.value)
    }

    static func y1(_ value: some SVGLengthConvertible) -> Self {
        SVGAttribute(name: "y1", value: value.svgLength.value)
    }

    static func x2(_ value: some SVGLengthConvertible) -> Self {
        SVGAttribute(name: "x2", value: value.svgLength.value)
    }

    static func y2(_ value: some SVGLengthConvertible) -> Self {
        SVGAttribute(name: "y2", value: value.svgLength.value)
    }
}

public extension SVGAttribute where Tag: SVGTrait.Attributes.Points {
    static func points(_ value: String) -> Self {
        SVGAttribute(name: "points", value: value)
    }
}

public extension SVGAttribute where Tag: SVGTrait.Attributes.Presentation {
    static func fill(_ value: SVGPaint) -> Self {
        SVGAttribute(name: "fill", value: value.value)
    }

    static func stroke(_ value: SVGPaint) -> Self {
        SVGAttribute(name: "stroke", value: value.value)
    }

    static func strokeWidth(_ value: some SVGLengthConvertible) -> Self {
        SVGAttribute(name: "stroke-width", value: value.svgLength.value)
    }

    static func strokeLinecap(_ value: String) -> Self {
        SVGAttribute(name: "stroke-linecap", value: value)
    }

    static func strokeLinejoin(_ value: String) -> Self {
        SVGAttribute(name: "stroke-linejoin", value: value)
    }

    static func strokeDasharray(_ value: String) -> Self {
        SVGAttribute(name: "stroke-dasharray", value: value)
    }

    static func opacity(_ value: SVGNumber) -> Self {
        SVGAttribute(name: "opacity", value: value.value)
    }

    static func transform(_ value: String) -> Self {
        SVGAttribute(name: "transform", value: value)
    }

    static func color(_ value: SVGPaint) -> Self {
        SVGAttribute(name: "color", value: value.value)
    }
}

public extension SVGAttribute where Tag: SVGTrait.Attributes.TextPresentation {
    static func fontFamily(_ value: String) -> Self {
        SVGAttribute(name: "font-family", value: value)
    }

    static func fontSize(_ value: some SVGLengthConvertible) -> Self {
        SVGAttribute(name: "font-size", value: value.svgLength.value)
    }

    static func textAnchor(_ value: String) -> Self {
        SVGAttribute(name: "text-anchor", value: value)
    }

    static func dominantBaseline(_ value: String) -> Self {
        SVGAttribute(name: "dominant-baseline", value: value)
    }
}

public extension SVGAttribute where Tag: SVGTrait.Attributes.Gradient {
    static func x1(_ value: some SVGLengthConvertible) -> Self {
        SVGAttribute(name: "x1", value: value.svgLength.value)
    }

    static func y1(_ value: some SVGLengthConvertible) -> Self {
        SVGAttribute(name: "y1", value: value.svgLength.value)
    }

    static func x2(_ value: some SVGLengthConvertible) -> Self {
        SVGAttribute(name: "x2", value: value.svgLength.value)
    }

    static func y2(_ value: some SVGLengthConvertible) -> Self {
        SVGAttribute(name: "y2", value: value.svgLength.value)
    }

    static func cx(_ value: some SVGLengthConvertible) -> Self {
        SVGAttribute(name: "cx", value: value.svgLength.value)
    }

    static func cy(_ value: some SVGLengthConvertible) -> Self {
        SVGAttribute(name: "cy", value: value.svgLength.value)
    }

    static func r(_ value: some SVGLengthConvertible) -> Self {
        SVGAttribute(name: "r", value: value.svgLength.value)
    }

    static func gradientUnits(_ value: String) -> Self {
        SVGAttribute(name: "gradientUnits", value: value)
    }
}

public extension SVGAttribute where Tag: SVGTrait.Attributes.GradientStop {
    static func offset(_ value: some SVGLengthConvertible) -> Self {
        SVGAttribute(name: "offset", value: value.svgLength.value)
    }

    static func stopColor(_ value: SVGPaint) -> Self {
        SVGAttribute(name: "stop-color", value: value.value)
    }

    static func stopOpacity(_ value: SVGNumber) -> Self {
        SVGAttribute(name: "stop-opacity", value: value.value)
    }
}
