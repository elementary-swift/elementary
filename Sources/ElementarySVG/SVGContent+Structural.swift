import Elementary

extension Never: SVGContent {}

extension Optional: SVGContent where Wrapped: SVGContent {
    @inlinable
    public var _isKnownEmpty: Bool {
        switch self {
        case .none: true
        case let .some(content): content._isKnownEmpty
        }
    }
}

extension EmptyContent: SVGContent {
    @inlinable
    public var _isKnownEmpty: Bool { true }
}

extension StringContent: SVGContent {}

extension Group: SVGContent where Content: SVGContent {
    @inlinable
    public var _isKnownEmpty: Bool {
        content._isKnownEmpty
    }
}

extension ForEach: SVGContent where Content: SVGContent {}

extension _ConditionalContent: SVGContent where TrueContent: SVGContent, FalseContent: SVGContent {
    @inlinable
    public var _isKnownEmpty: Bool {
        switch value {
        case let .trueContent(content): content._isKnownEmpty
        case let .falseContent(content): content._isKnownEmpty
        }
    }
}

extension _ArrayContent: SVGContent where Element: SVGContent {
    @inlinable
    public var _isKnownEmpty: Bool { value.isEmpty }
}

extension _TupleContent2: SVGContent where V0: SVGContent, V1: SVGContent {}

extension _TupleContent3: SVGContent where V0: SVGContent, V1: SVGContent, V2: SVGContent {}

extension _TupleContent4: SVGContent where V0: SVGContent, V1: SVGContent, V2: SVGContent, V3: SVGContent {}

extension _TupleContent5: SVGContent where V0: SVGContent, V1: SVGContent, V2: SVGContent, V3: SVGContent, V4: SVGContent {}

extension _TupleContent6: SVGContent where V0: SVGContent, V1: SVGContent, V2: SVGContent, V3: SVGContent, V4: SVGContent, V5: SVGContent {}

#if !hasFeature(Embedded)
extension AsyncContent: SVGContent where Content: SVGContent {}

extension AsyncForEach: SVGContent where Content: SVGContent {}

@available(iOS 17, *)
extension _TupleContent: SVGContent where repeat each Child: SVGContent {}
#endif
