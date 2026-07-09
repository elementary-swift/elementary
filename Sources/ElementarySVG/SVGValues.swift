public struct SVGLength: ExpressibleByStringLiteral, ExpressibleByIntegerLiteral, ExpressibleByFloatLiteral, Sendable {
    public let value: String

    public init(_ value: String) {
        self.value = value
    }

    public init(_ value: Int) {
        self.value = "\(value)"
    }

    public init(_ value: Double) {
        self.value = "\(value)"
    }

    public init(stringLiteral value: String) {
        self.value = value
    }

    public init(integerLiteral value: Int) {
        self.value = "\(value)"
    }

    public init(floatLiteral value: Double) {
        self.value = "\(value)"
    }

    public static func px(_ value: Int) -> Self {
        .init("\(value)px")
    }

    public static func px(_ value: Double) -> Self {
        .init("\(value)px")
    }

    public static func percent(_ value: Int) -> Self {
        .init("\(value)%")
    }

    public static func percent(_ value: Double) -> Self {
        .init("\(value)%")
    }
}

public protocol SVGLengthConvertible {
    var svgLength: SVGLength { get }
}

extension SVGLength: SVGLengthConvertible {
    public var svgLength: SVGLength { self }
}

extension Int: SVGLengthConvertible {
    public var svgLength: SVGLength { SVGLength(self) }
}

extension Double: SVGLengthConvertible {
    public var svgLength: SVGLength { SVGLength(self) }
}

extension String: SVGLengthConvertible {
    public var svgLength: SVGLength { SVGLength(self) }
}

public struct SVGNumber: ExpressibleByStringLiteral, ExpressibleByIntegerLiteral, ExpressibleByFloatLiteral, Sendable {
    public let value: String

    public init(_ value: String) {
        self.value = value
    }

    public init(_ value: Int) {
        self.value = "\(value)"
    }

    public init(_ value: Double) {
        self.value = "\(value)"
    }

    public init(stringLiteral value: String) {
        self.value = value
    }

    public init(integerLiteral value: Int) {
        self.value = "\(value)"
    }

    public init(floatLiteral value: Double) {
        self.value = "\(value)"
    }
}

public struct SVGPaint: ExpressibleByStringLiteral, Sendable {
    public let value: String

    public init(_ value: String) {
        self.value = value
    }

    public init(stringLiteral value: String) {
        self.value = value
    }

    public static var none: Self { .init("none") }
    public static var currentColor: Self { .init("currentColor") }
}

public struct SVGPathData: ExpressibleByStringLiteral, Sendable {
    public let value: String

    public init(_ value: String) {
        self.value = value
    }

    public init(stringLiteral value: String) {
        self.value = value
    }
}
