// hand-rolled tuples types for embedded support (variadic generics are not supported in Embedded ATM)
// unfortunately variadic generics perform significantly worse than the hand-rolled tuples,
// so we can just use them for normal HTML rendering as well

public extension ContentBuilder {
    @inlinable
    static func buildBlock<V0, V1>(_ v0: V0, _ v1: V1) -> _TupleContent2<V0, V1> {
        _TupleContent2(v0: v0, v1: v1)
    }

    @inlinable
    static func buildBlock<V0, V1, V2>(_ v0: V0, _ v1: V1, _ v2: V2) -> _TupleContent3<V0, V1, V2> {
        _TupleContent3(v0: v0, v1: v1, v2: v2)
    }

    @inlinable
    static func buildBlock<V0, V1, V2, V3>(_ v0: V0, _ v1: V1, _ v2: V2, _ v3: V3) -> _TupleContent4<V0, V1, V2, V3> {
        _TupleContent4(v0: v0, v1: v1, v2: v2, v3: v3)
    }

    @inlinable
    static func buildBlock<V0, V1, V2, V3, V4>(
        _ v0: V0,
        _ v1: V1,
        _ v2: V2,
        _ v3: V3,
        _ v4: V4
    ) -> _TupleContent5<V0, V1, V2, V3, V4> {
        _TupleContent5(v0: v0, v1: v1, v2: v2, v3: v3, v4: v4)
    }

    @inlinable
    static func buildBlock<V0, V1, V2, V3, V4, V5>(
        _ v0: V0,
        _ v1: V1,
        _ v2: V2,
        _ v3: V3,
        _ v4: V4,
        _ v5: V5
    ) -> _TupleContent6<V0, V1, V2, V3, V4, V5> {
        _TupleContent6(v0: v0, v1: v1, v2: v2, v3: v3, v4: v4, v5: v5)
    }

    // 7...12 use nested tuples: first 6 elements + remainder

    @inlinable
    static func buildBlock<V0, V1, V2, V3, V4, V5, V6>(
        _ v0: V0,
        _ v1: V1,
        _ v2: V2,
        _ v3: V3,
        _ v4: V4,
        _ v5: V5,
        _ v6: V6
    ) -> _TupleContent2<_TupleContent6<V0, V1, V2, V3, V4, V5>, V6> {
        .init(v0: .init(v0: v0, v1: v1, v2: v2, v3: v3, v4: v4, v5: v5), v1: v6)
    }

    @inlinable
    static func buildBlock<V0, V1, V2, V3, V4, V5, V6, V7>(
        _ v0: V0,
        _ v1: V1,
        _ v2: V2,
        _ v3: V3,
        _ v4: V4,
        _ v5: V5,
        _ v6: V6,
        _ v7: V7
    ) -> _TupleContent2<_TupleContent6<V0, V1, V2, V3, V4, V5>, _TupleContent2<V6, V7>> {
        .init(v0: .init(v0: v0, v1: v1, v2: v2, v3: v3, v4: v4, v5: v5), v1: .init(v0: v6, v1: v7))
    }

    @inlinable
    static func buildBlock<V0, V1, V2, V3, V4, V5, V6, V7, V8>(
        _ v0: V0,
        _ v1: V1,
        _ v2: V2,
        _ v3: V3,
        _ v4: V4,
        _ v5: V5,
        _ v6: V6,
        _ v7: V7,
        _ v8: V8
    ) -> _TupleContent2<_TupleContent6<V0, V1, V2, V3, V4, V5>, _TupleContent3<V6, V7, V8>> {
        .init(v0: .init(v0: v0, v1: v1, v2: v2, v3: v3, v4: v4, v5: v5), v1: .init(v0: v6, v1: v7, v2: v8))
    }

    @inlinable
    static func buildBlock<V0, V1, V2, V3, V4, V5, V6, V7, V8, V9>(
        _ v0: V0,
        _ v1: V1,
        _ v2: V2,
        _ v3: V3,
        _ v4: V4,
        _ v5: V5,
        _ v6: V6,
        _ v7: V7,
        _ v8: V8,
        _ v9: V9
    ) -> _TupleContent2<_TupleContent6<V0, V1, V2, V3, V4, V5>, _TupleContent4<V6, V7, V8, V9>> {
        .init(v0: .init(v0: v0, v1: v1, v2: v2, v3: v3, v4: v4, v5: v5), v1: .init(v0: v6, v1: v7, v2: v8, v3: v9))
    }

    @inlinable
    static func buildBlock<V0, V1, V2, V3, V4, V5, V6, V7, V8, V9, V10>(
        _ v0: V0,
        _ v1: V1,
        _ v2: V2,
        _ v3: V3,
        _ v4: V4,
        _ v5: V5,
        _ v6: V6,
        _ v7: V7,
        _ v8: V8,
        _ v9: V9,
        _ v10: V10
    ) -> _TupleContent2<_TupleContent6<V0, V1, V2, V3, V4, V5>, _TupleContent5<V6, V7, V8, V9, V10>> {
        .init(v0: .init(v0: v0, v1: v1, v2: v2, v3: v3, v4: v4, v5: v5), v1: .init(v0: v6, v1: v7, v2: v8, v3: v9, v4: v10))
    }

    @inlinable
    static func buildBlock<
        V0,
        V1,
        V2,
        V3,
        V4,
        V5,
        V6,
        V7,
        V8,
        V9,
        V10,
        V11
    >(
        _ v0: V0,
        _ v1: V1,
        _ v2: V2,
        _ v3: V3,
        _ v4: V4,
        _ v5: V5,
        _ v6: V6,
        _ v7: V7,
        _ v8: V8,
        _ v9: V9,
        _ v10: V10,
        _ v11: V11
    ) -> _TupleContent2<_TupleContent6<V0, V1, V2, V3, V4, V5>, _TupleContent6<V6, V7, V8, V9, V10, V11>> {
        .init(v0: .init(v0: v0, v1: v1, v2: v2, v3: v3, v4: v4, v5: v5), v1: .init(v0: v6, v1: v7, v2: v8, v3: v9, v4: v10, v5: v11))
    }

    // variadic generics currently not supported in embedded
    #if !hasFeature(Embedded)
    @inlinable
    @available(iOS 17, *)
    static func buildBlock<each Content>(_ content: repeat each Content) -> _TupleContent<repeat each Content> {
        _TupleContent(repeat each content)
    }
    #endif
}

extension _TupleContent2: Sendable where V0: Sendable, V1: Sendable {}
public struct _TupleContent2<V0, V1> {
    public let v0: V0
    public let v1: V1

    @inlinable
    public init(v0: V0, v1: V1) {
        self.v0 = v0
        self.v1 = v1
    }
}

extension _TupleContent2: _Renderable where V0: _Renderable, V1: _Renderable {
    @inlinable
    public static func _render<Renderer: _HTMLRendering>(
        _ html: consuming Self,
        into renderer: inout Renderer,
        with context: consuming _RenderingContext
    ) {
        context.assertNoAttributes(self)

        V0._render(html.v0, into: &renderer, with: copy context)
        V1._render(html.v1, into: &renderer, with: copy context)
    }

    @inlinable
    @_unavailableInEmbedded
    public static func _render<Renderer: _AsyncHTMLRendering>(
        _ html: consuming Self,
        into renderer: inout Renderer,
        with context: consuming _RenderingContext
    ) async throws {
        context.assertNoAttributes(self)

        try await V0._render(html.v0, into: &renderer, with: copy context)
        try await V1._render(html.v1, into: &renderer, with: copy context)
    }
}

extension _TupleContent2: MarkupContent where V0: MarkupContent, V1: MarkupContent {
    public typealias Body = Never
}

extension _TupleContent2: HTML where V0: HTML, V1: HTML {}

extension _TupleContent3: Sendable where V0: Sendable, V1: Sendable, V2: Sendable {}
public struct _TupleContent3<V0, V1, V2> {
    public let v0: V0
    public let v1: V1
    public let v2: V2

    @inlinable
    public init(v0: V0, v1: V1, v2: V2) {
        self.v0 = v0
        self.v1 = v1
        self.v2 = v2
    }
}

extension _TupleContent3: _Renderable where V0: _Renderable, V1: _Renderable, V2: _Renderable {
    @inlinable
    public static func _render<Renderer: _HTMLRendering>(
        _ html: consuming Self,
        into renderer: inout Renderer,
        with context: consuming _RenderingContext
    ) {
        context.assertNoAttributes(self)

        V0._render(html.v0, into: &renderer, with: copy context)
        V1._render(html.v1, into: &renderer, with: copy context)
        V2._render(html.v2, into: &renderer, with: copy context)
    }

    @inlinable
    @_unavailableInEmbedded
    public static func _render<Renderer: _AsyncHTMLRendering>(
        _ html: consuming Self,
        into renderer: inout Renderer,
        with context: consuming _RenderingContext
    ) async throws {
        context.assertNoAttributes(self)

        try await V0._render(html.v0, into: &renderer, with: copy context)
        try await V1._render(html.v1, into: &renderer, with: copy context)
        try await V2._render(html.v2, into: &renderer, with: copy context)
    }
}

extension _TupleContent3: MarkupContent where V0: MarkupContent, V1: MarkupContent, V2: MarkupContent {
    public typealias Body = Never
}

extension _TupleContent3: HTML where V0: HTML, V1: HTML, V2: HTML {}

extension _TupleContent4: Sendable where V0: Sendable, V1: Sendable, V2: Sendable, V3: Sendable {}
public struct _TupleContent4<V0, V1, V2, V3> {
    public let v0: V0
    public let v1: V1
    public let v2: V2
    public let v3: V3

    @inlinable
    public init(v0: V0, v1: V1, v2: V2, v3: V3) {
        self.v0 = v0
        self.v1 = v1
        self.v2 = v2
        self.v3 = v3
    }
}

extension _TupleContent4: _Renderable where V0: _Renderable, V1: _Renderable, V2: _Renderable, V3: _Renderable {
    @inlinable
    public static func _render<Renderer: _HTMLRendering>(
        _ html: consuming Self,
        into renderer: inout Renderer,
        with context: consuming _RenderingContext
    ) {
        context.assertNoAttributes(self)

        V0._render(html.v0, into: &renderer, with: copy context)
        V1._render(html.v1, into: &renderer, with: copy context)
        V2._render(html.v2, into: &renderer, with: copy context)
        V3._render(html.v3, into: &renderer, with: copy context)
    }

    @inlinable
    @_unavailableInEmbedded
    public static func _render<Renderer: _AsyncHTMLRendering>(
        _ html: consuming Self,
        into renderer: inout Renderer,
        with context: consuming _RenderingContext
    ) async throws {
        context.assertNoAttributes(self)

        try await V0._render(html.v0, into: &renderer, with: copy context)
        try await V1._render(html.v1, into: &renderer, with: copy context)
        try await V2._render(html.v2, into: &renderer, with: copy context)
        try await V3._render(html.v3, into: &renderer, with: copy context)
    }
}

extension _TupleContent4: MarkupContent where V0: MarkupContent, V1: MarkupContent, V2: MarkupContent, V3: MarkupContent {
    public typealias Body = Never
}

extension _TupleContent4: HTML where V0: HTML, V1: HTML, V2: HTML, V3: HTML {}

extension _TupleContent5: Sendable where V0: Sendable, V1: Sendable, V2: Sendable, V3: Sendable, V4: Sendable {}
public struct _TupleContent5<V0, V1, V2, V3, V4> {
    public let v0: V0
    public let v1: V1
    public let v2: V2
    public let v3: V3
    public let v4: V4

    @inlinable
    public init(v0: V0, v1: V1, v2: V2, v3: V3, v4: V4) {
        self.v0 = v0
        self.v1 = v1
        self.v2 = v2
        self.v3 = v3
        self.v4 = v4
    }
}

extension _TupleContent5: _Renderable where V0: _Renderable, V1: _Renderable, V2: _Renderable, V3: _Renderable, V4: _Renderable {
    @inlinable
    public static func _render<Renderer: _HTMLRendering>(
        _ html: consuming Self,
        into renderer: inout Renderer,
        with context: consuming _RenderingContext
    ) {
        context.assertNoAttributes(self)

        V0._render(html.v0, into: &renderer, with: copy context)
        V1._render(html.v1, into: &renderer, with: copy context)
        V2._render(html.v2, into: &renderer, with: copy context)
        V3._render(html.v3, into: &renderer, with: copy context)
        V4._render(html.v4, into: &renderer, with: copy context)
    }

    @inlinable
    @_unavailableInEmbedded
    public static func _render<Renderer: _AsyncHTMLRendering>(
        _ html: consuming Self,
        into renderer: inout Renderer,
        with context: consuming _RenderingContext
    ) async throws {
        context.assertNoAttributes(self)

        try await V0._render(html.v0, into: &renderer, with: copy context)
        try await V1._render(html.v1, into: &renderer, with: copy context)
        try await V2._render(html.v2, into: &renderer, with: copy context)
        try await V3._render(html.v3, into: &renderer, with: copy context)
        try await V4._render(html.v4, into: &renderer, with: copy context)
    }
}

extension _TupleContent5: MarkupContent where V0: MarkupContent, V1: MarkupContent, V2: MarkupContent, V3: MarkupContent, V4: MarkupContent {
    public typealias Body = Never
}

extension _TupleContent5: HTML where V0: HTML, V1: HTML, V2: HTML, V3: HTML, V4: HTML {}

extension _TupleContent6: Sendable where V0: Sendable, V1: Sendable, V2: Sendable, V3: Sendable, V4: Sendable, V5: Sendable {}
public struct _TupleContent6<V0, V1, V2, V3, V4, V5> {
    public let v0: V0
    public let v1: V1
    public let v2: V2
    public let v3: V3
    public let v4: V4
    public let v5: V5

    @inlinable
    public init(v0: V0, v1: V1, v2: V2, v3: V3, v4: V4, v5: V5) {
        self.v0 = v0
        self.v1 = v1
        self.v2 = v2
        self.v3 = v3
        self.v4 = v4
        self.v5 = v5
    }
}

extension _TupleContent6: _Renderable where V0: _Renderable, V1: _Renderable, V2: _Renderable, V3: _Renderable, V4: _Renderable, V5: _Renderable {
    @inlinable
    public static func _render<Renderer: _HTMLRendering>(
        _ html: consuming Self,
        into renderer: inout Renderer,
        with context: consuming _RenderingContext
    ) {
        context.assertNoAttributes(self)

        V0._render(html.v0, into: &renderer, with: copy context)
        V1._render(html.v1, into: &renderer, with: copy context)
        V2._render(html.v2, into: &renderer, with: copy context)
        V3._render(html.v3, into: &renderer, with: copy context)
        V4._render(html.v4, into: &renderer, with: copy context)
        V5._render(html.v5, into: &renderer, with: copy context)
    }

    @inlinable
    @_unavailableInEmbedded
    public static func _render<Renderer: _AsyncHTMLRendering>(
        _ html: consuming Self,
        into renderer: inout Renderer,
        with context: consuming _RenderingContext
    ) async throws {
        context.assertNoAttributes(self)

        try await V0._render(html.v0, into: &renderer, with: copy context)
        try await V1._render(html.v1, into: &renderer, with: copy context)
        try await V2._render(html.v2, into: &renderer, with: copy context)
        try await V3._render(html.v3, into: &renderer, with: copy context)
        try await V4._render(html.v4, into: &renderer, with: copy context)
        try await V5._render(html.v5, into: &renderer, with: copy context)
    }
}

extension _TupleContent6: MarkupContent where V0: MarkupContent, V1: MarkupContent, V2: MarkupContent, V3: MarkupContent, V4: MarkupContent, V5: MarkupContent {
    public typealias Body = Never
}

extension _TupleContent6: HTML where V0: HTML, V1: HTML, V2: HTML, V3: HTML, V4: HTML, V5: HTML {}

// variadic generics currently not supported in embedded
#if !hasFeature(Embedded)
@available(iOS 17, *)
extension _TupleContent: Sendable where repeat each Child: Sendable {}

@available(iOS 17, *)
public struct _TupleContent<each Child> {
    public let value: (repeat each Child)

    @inlinable
    public init(_ value: repeat each Child) {
        self.value = (repeat each value)
    }
}

@available(iOS 17, *)
extension _TupleContent: _Renderable where repeat each Child: _Renderable {
    @inlinable
    public static func _render<Renderer: _HTMLRendering>(
        _ html: consuming Self,
        into renderer: inout Renderer,
        with context: consuming _RenderingContext
    ) {
        context.assertNoAttributes(self)

        // NOTE: use iteration in swift 6
        func renderElement<Element: _Renderable>(_ element: Element, _ renderer: inout Renderer) {
            Element._render(element, into: &renderer, with: copy context)
        }
        repeat renderElement(each html.value, &renderer)
    }

    @inlinable
    @_unavailableInEmbedded
    public static func _render<Renderer: _AsyncHTMLRendering>(
        _ html: consuming Self,
        into renderer: inout Renderer,
        with context: consuming _RenderingContext
    ) async throws {
        context.assertNoAttributes(self)

        // NOTE: use iteration in swift 6
        func renderElement<Element: _Renderable>(_ element: Element, _ renderer: inout Renderer) async throws {
            try await Element._render(element, into: &renderer, with: copy context)
        }
        repeat try await renderElement(each html.value, &renderer)
    }
}

@available(iOS 17, *)
extension _TupleContent: MarkupContent where repeat each Child: MarkupContent {
    public typealias Body = Never
}

@available(iOS 17, *)
extension _TupleContent: HTML where repeat each Child: HTML {}
#endif

/// Deprecated compatibility alias for ``_TupleContent2``.
///
/// Prefer ``_TupleContent2`` for new code. This alias is kept for the upgrade path and will be removed in a future release.
@available(*, deprecated, renamed: "_TupleContent2")
public typealias _HTMLTuple2<V0, V1> = _TupleContent2<V0, V1>

/// Deprecated compatibility alias for ``_TupleContent3``.
///
/// Prefer ``_TupleContent3`` for new code. This alias is kept for the upgrade path and will be removed in a future release.
@available(*, deprecated, renamed: "_TupleContent3")
public typealias _HTMLTuple3<V0, V1, V2> = _TupleContent3<V0, V1, V2>

/// Deprecated compatibility alias for ``_TupleContent4``.
///
/// Prefer ``_TupleContent4`` for new code. This alias is kept for the upgrade path and will be removed in a future release.
@available(*, deprecated, renamed: "_TupleContent4")
public typealias _HTMLTuple4<V0, V1, V2, V3> = _TupleContent4<V0, V1, V2, V3>

/// Deprecated compatibility alias for ``_TupleContent5``.
///
/// Prefer ``_TupleContent5`` for new code. This alias is kept for the upgrade path and will be removed in a future release.
@available(*, deprecated, renamed: "_TupleContent5")
public typealias _HTMLTuple5<V0, V1, V2, V3, V4> = _TupleContent5<V0, V1, V2, V3, V4>

/// Deprecated compatibility alias for ``_TupleContent6``.
///
/// Prefer ``_TupleContent6`` for new code. This alias is kept for the upgrade path and will be removed in a future release.
@available(*, deprecated, renamed: "_TupleContent6")
public typealias _HTMLTuple6<V0, V1, V2, V3, V4, V5> = _TupleContent6<V0, V1, V2, V3, V4, V5>

#if !hasFeature(Embedded)
/// Deprecated compatibility alias for ``_TupleContent``.
///
/// Prefer ``_TupleContent`` for new code. This alias is kept for the upgrade path and will be removed in a future release.
@available(iOS 17, *)
@available(*, deprecated, renamed: "_TupleContent")
public typealias _HTMLTuple<each Child> = _TupleContent<repeat each Child>
#endif
