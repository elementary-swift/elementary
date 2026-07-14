extension Never: HTML {}

extension Optional: HTML where Wrapped: HTML {}

extension EmptyContent: HTML {}

extension StringContent: HTML {}

extension Group: HTML where Content: HTML {}

extension ForEach: HTML where Content: HTML {}

extension _ConditionalContent: HTML where TrueContent: HTML, FalseContent: HTML {}

extension _ArrayContent: HTML where Element: HTML {}

extension _TupleContent2: HTML where V0: HTML, V1: HTML {}

extension _TupleContent3: HTML where V0: HTML, V1: HTML, V2: HTML {}

extension _TupleContent4: HTML where V0: HTML, V1: HTML, V2: HTML, V3: HTML {}

extension _TupleContent5: HTML where V0: HTML, V1: HTML, V2: HTML, V3: HTML, V4: HTML {}

extension _TupleContent6: HTML where V0: HTML, V1: HTML, V2: HTML, V3: HTML, V4: HTML, V5: HTML {}

#if !hasFeature(Embedded)
@_unavailableInEmbedded
extension AsyncContent: HTML where Content: HTML {}

extension AsyncForEach: HTML where Content: HTML {}

extension _ModifiedTaskLocal: HTML where Content: HTML {}

@available(iOS 17, *)
extension _TupleContent: HTML where repeat each Child: HTML {}
#endif
