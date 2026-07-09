import Elementary

public protocol SVGTagDefinition: MarkupTagDefinition {}

public protocol SVGContent<Tag>: MarkupContent where Tag: SVGTagDefinition, Body: SVGContent {}

extension Never: SVGTagDefinition {}
extension Never: SVGContent {}

extension Optional: SVGContent where Wrapped: SVGContent {}

extension EmptyContent: SVGContent {}
extension StringContent: SVGContent {}

extension Group: SVGContent where Content: SVGContent {}

extension ForEach: SVGContent where Content: SVGContent {}

extension _ConditionalContent: SVGContent where TrueContent: SVGContent, FalseContent: SVGContent {}

extension _ArrayContent: SVGContent where Element: SVGContent {}

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

extension _AttributedElement: SVGContent where Tag: SVGTagDefinition, Content: SVGContent {}

public typealias SVGAttribute<Tag: SVGTagDefinition> = MarkupAttribute<Tag>
public typealias SVGElement<Tag: SVGTagDefinition, Content: SVGContent> = MarkupElement<Tag, Content>

extension MarkupElement: SVGContent where Tag: SVGTagDefinition, Content: SVGContent {}
