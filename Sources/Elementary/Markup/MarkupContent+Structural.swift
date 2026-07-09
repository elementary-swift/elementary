extension Never: MarkupContent {
    public typealias Tag = Never
    public typealias Body = Never
}

extension Optional: MarkupContent where Wrapped: MarkupContent {
    public typealias Tag = Wrapped.Tag
    public typealias Body = Never
}

extension EmptyContent: MarkupContent {
    public typealias Tag = Never
    public typealias Body = Never
}

extension StringContent: MarkupContent {
    public typealias Tag = Never
    public typealias Body = Never
}

extension Group: MarkupContent where Content: MarkupContent {
    public typealias Body = Never
}

extension ForEach: MarkupContent where Content: MarkupContent {
    public typealias Body = Never
}

extension _ConditionalContent: MarkupContent where TrueContent: MarkupContent, FalseContent: MarkupContent {
    public typealias Body = Never
}

extension _ConditionalContent where TrueContent: MarkupContent, FalseContent: MarkupContent, TrueContent.Tag == FalseContent.Tag {
    public typealias Tag = TrueContent.Tag
}

extension _ArrayContent: MarkupContent where Element: MarkupContent {
    public typealias Tag = Never
    public typealias Body = Never
}

extension _TupleContent2: MarkupContent where V0: MarkupContent, V1: MarkupContent {
    public typealias Body = Never
}

extension _TupleContent3: MarkupContent where V0: MarkupContent, V1: MarkupContent, V2: MarkupContent {
    public typealias Body = Never
}

extension _TupleContent4: MarkupContent where V0: MarkupContent, V1: MarkupContent, V2: MarkupContent, V3: MarkupContent {
    public typealias Body = Never
}

extension _TupleContent5: MarkupContent
where V0: MarkupContent, V1: MarkupContent, V2: MarkupContent, V3: MarkupContent, V4: MarkupContent {
    public typealias Body = Never
}

extension _TupleContent6: MarkupContent
where V0: MarkupContent, V1: MarkupContent, V2: MarkupContent, V3: MarkupContent, V4: MarkupContent, V5: MarkupContent {
    public typealias Body = Never
}

#if !hasFeature(Embedded)
@_unavailableInEmbedded
extension AsyncContent: MarkupContent where Content: MarkupContent {
    public typealias Tag = Content.Tag
    public typealias Body = Never
}

extension AsyncForEach: MarkupContent where Content: MarkupContent {
    public typealias Body = Never
}

extension _ModifiedTaskLocal: MarkupContent where Content: MarkupContent {
    public typealias Tag = Content.Tag
    public typealias Body = Never
}

@available(iOS 17, *)
extension _TupleContent: MarkupContent where repeat each Child: MarkupContent {
    public typealias Body = Never
}
#endif
