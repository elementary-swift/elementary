/// A namespace for typed SVG attribute values.
public enum SVGAttributeValue {}

public extension SVGAttributeValue {
    struct Length: ExpressibleByStringLiteral, ExpressibleByIntegerLiteral, ExpressibleByFloatLiteral, Sendable, Equatable {
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
}

public extension SVGAttributeValue {
    struct Number: ExpressibleByIntegerLiteral, ExpressibleByFloatLiteral, Sendable, Equatable {
        public let value: String

        public init(_ value: Int) {
            self.value = "\(value)"
        }

        public init(_ value: Double) {
            self.value = "\(value)"
        }

        public init(integerLiteral value: Int) {
            self.value = "\(value)"
        }

        public init(floatLiteral value: Double) {
            self.value = "\(value)"
        }
    }
}

public extension SVGAttributeValue {
    struct Paint: ExpressibleByStringLiteral, Sendable, Equatable {
        public let value: String

        public init(_ value: String) {
            self.value = value
        }

        public init(stringLiteral value: String) {
            self.value = value
        }

        public static var none: Self { .init("none") }
    }
}

public extension SVGAttributeValue {
    struct FillRule: ExpressibleByStringLiteral, RawRepresentable, Sendable, Equatable {
        public let rawValue: String

        public init(rawValue: String) {
            self.rawValue = rawValue
        }

        public init(stringLiteral value: String) {
            rawValue = value
        }

        public static var nonzero: Self { "nonzero" }
        public static var evenodd: Self { "evenodd" }
    }
}

public extension SVGAttributeValue {
    struct LineCap: ExpressibleByStringLiteral, RawRepresentable, Sendable, Equatable {
        public let rawValue: String

        public init(rawValue: String) {
            self.rawValue = rawValue
        }

        public init(stringLiteral value: String) {
            rawValue = value
        }

        public static var butt: Self { "butt" }
        public static var round: Self { "round" }
        public static var square: Self { "square" }
    }
}

public extension SVGAttributeValue {
    struct LineJoin: ExpressibleByStringLiteral, RawRepresentable, Sendable, Equatable {
        public let rawValue: String

        public init(rawValue: String) {
            self.rawValue = rawValue
        }

        public init(stringLiteral value: String) {
            rawValue = value
        }

        public static var miter: Self { "miter" }
        public static var round: Self { "round" }
        public static var bevel: Self { "bevel" }
        public static var arcs: Self { "arcs" }
        public static var miterClip: Self { "miter-clip" }
    }
}

public extension SVGAttributeValue {
    struct CoordinateSystem: ExpressibleByStringLiteral, RawRepresentable, Sendable, Equatable {
        public let rawValue: String

        public init(rawValue: String) {
            self.rawValue = rawValue
        }

        public init(stringLiteral value: String) {
            rawValue = value
        }

        public static var userSpaceOnUse: Self { "userSpaceOnUse" }
        public static var objectBoundingBox: Self { "objectBoundingBox" }
    }
}

public extension SVGAttributeValue {
    struct SpreadMethod: ExpressibleByStringLiteral, RawRepresentable, Sendable, Equatable {
        public let rawValue: String

        public init(rawValue: String) {
            self.rawValue = rawValue
        }

        public init(stringLiteral value: String) {
            rawValue = value
        }

        public static var pad: Self { "pad" }
        public static var reflect: Self { "reflect" }
        public static var `repeat`: Self { "repeat" }
    }
}

public extension SVGAttributeValue {
    struct MaskType: ExpressibleByStringLiteral, RawRepresentable, Sendable, Equatable {
        public let rawValue: String

        public init(rawValue: String) {
            self.rawValue = rawValue
        }

        public init(stringLiteral value: String) {
            rawValue = value
        }

        public static var alpha: Self { "alpha" }
        public static var luminance: Self { "luminance" }
    }
}

public extension SVGAttributeValue {
    struct MarkerUnits: ExpressibleByStringLiteral, RawRepresentable, Sendable, Equatable {
        public let rawValue: String

        public init(rawValue: String) {
            self.rawValue = rawValue
        }

        public init(stringLiteral value: String) {
            rawValue = value
        }

        public static var strokeWidth: Self { "strokeWidth" }
        public static var userSpaceOnUse: Self { "userSpaceOnUse" }
    }
}

public extension SVGAttributeValue {
    struct Orient: ExpressibleByStringLiteral, RawRepresentable, Sendable, Equatable {
        public let rawValue: String

        public init(rawValue: String) {
            self.rawValue = rawValue
        }

        public init(stringLiteral value: String) {
            rawValue = value
        }

        public static var auto: Self { "auto" }
        public static var autoStartReverse: Self { "auto-start-reverse" }
    }
}

public extension SVGAttributeValue {
    struct PreserveAspectRatio: ExpressibleByStringLiteral, RawRepresentable, Sendable, Equatable {
        public struct MeetOrSlice: ExpressibleByStringLiteral, RawRepresentable, Sendable, Equatable {
            public let rawValue: String

            public init(rawValue: String) {
                self.rawValue = rawValue
            }

            public init(stringLiteral value: String) {
                rawValue = value
            }

            public static var meet: Self { "meet" }
            public static var slice: Self { "slice" }
        }

        public let rawValue: String

        public init(rawValue: String) {
            self.rawValue = rawValue
        }

        public init(stringLiteral value: String) {
            rawValue = value
        }

        public static var none: Self { "none" }

        public static func xMinYMin(_ meetOrSlice: MeetOrSlice? = nil) -> Self { .alignment("xMinYMin", meetOrSlice) }
        public static func xMidYMin(_ meetOrSlice: MeetOrSlice? = nil) -> Self { .alignment("xMidYMin", meetOrSlice) }
        public static func xMaxYMin(_ meetOrSlice: MeetOrSlice? = nil) -> Self { .alignment("xMaxYMin", meetOrSlice) }
        public static func xMinYMid(_ meetOrSlice: MeetOrSlice? = nil) -> Self { .alignment("xMinYMid", meetOrSlice) }
        public static func xMidYMid(_ meetOrSlice: MeetOrSlice? = nil) -> Self { .alignment("xMidYMid", meetOrSlice) }
        public static func xMaxYMid(_ meetOrSlice: MeetOrSlice? = nil) -> Self { .alignment("xMaxYMid", meetOrSlice) }
        public static func xMinYMax(_ meetOrSlice: MeetOrSlice? = nil) -> Self { .alignment("xMinYMax", meetOrSlice) }
        public static func xMidYMax(_ meetOrSlice: MeetOrSlice? = nil) -> Self { .alignment("xMidYMax", meetOrSlice) }
        public static func xMaxYMax(_ meetOrSlice: MeetOrSlice? = nil) -> Self { .alignment("xMaxYMax", meetOrSlice) }

        private static func alignment(_ alignment: String, _ meetOrSlice: MeetOrSlice?) -> Self {
            guard let meetOrSlice else { return .init(rawValue: alignment) }
            return .init(rawValue: "\(alignment) \(meetOrSlice.rawValue)")
        }
    }
}
