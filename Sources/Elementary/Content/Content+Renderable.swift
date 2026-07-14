#if !hasFeature(Embedded)
extension Optional: _Renderable where Wrapped: _Renderable {
    @inlinable
    public static func _render<Renderer: _HTMLRendering>(
        _ html: consuming Self,
        into renderer: inout Renderer,
        with context: consuming _RenderingContext
    ) {
        switch html {
        case .none: return
        case let .some(value): Wrapped._render(value, into: &renderer, with: context)
        }
    }

    @inlinable
    @_unavailableInEmbedded
    public static func _render<Renderer: _AsyncHTMLRendering>(
        _ html: consuming Self,
        into renderer: inout Renderer,
        with context: consuming _RenderingContext
    ) async throws {
        switch html {
        case .none: break
        case let .some(value): try await Wrapped._render(value, into: &renderer, with: context)
        }
    }
}

extension EmptyContent: _Renderable {
    @inlinable
    public static func _render<Renderer: _HTMLRendering>(
        _ html: consuming Self,
        into renderer: inout Renderer,
        with context: consuming _RenderingContext
    ) {
        context.assertNoAttributes(self)
    }

    @inlinable
    @_unavailableInEmbedded
    public static func _render<Renderer: _AsyncHTMLRendering>(
        _ html: consuming Self,
        into renderer: inout Renderer,
        with context: consuming _RenderingContext
    ) async throws {
        context.assertNoAttributes(self)
    }
}

extension StringContent: _Renderable {
    @inlinable
    public static func _render<Renderer: _HTMLRendering>(
        _ html: consuming Self,
        into renderer: inout Renderer,
        with context: consuming _RenderingContext
    ) {
        context.assertNoAttributes(self)
        renderer.appendToken(.text(html.text))
    }

    @inlinable
    @_unavailableInEmbedded
    public static func _render<Renderer: _AsyncHTMLRendering>(
        _ html: consuming Self,
        into renderer: inout Renderer,
        with context: consuming _RenderingContext
    ) async throws {
        context.assertNoAttributes(self)
        try await renderer.appendToken(.text(html.text))
    }
}

extension Group: _Renderable where Content: _Renderable {
    @inlinable
    public static func _render<Renderer: _HTMLRendering>(
        _ html: consuming Self,
        into renderer: inout Renderer,
        with context: consuming _RenderingContext
    ) {
        context.assertNoAttributes(self)
        Content._render(html.content, into: &renderer, with: context)
    }

    @inlinable
    @_unavailableInEmbedded
    public static func _render<Renderer: _AsyncHTMLRendering>(
        _ html: consuming Self,
        into renderer: inout Renderer,
        with context: consuming _RenderingContext
    ) async throws {
        context.assertNoAttributes(self)
        try await Content._render(html.content, into: &renderer, with: context)
    }
}

extension ForEach: _Renderable where Content: _Renderable {
    @inlinable
    public static func _render<Renderer: _HTMLRendering>(
        _ html: consuming Self,
        into renderer: inout Renderer,
        with context: consuming _RenderingContext
    ) {
        context.assertNoAttributes(self)

        for element in html._data {
            Content._render(html._contentBuilder(element), into: &renderer, with: copy context)
        }
    }

    @inlinable
    @_unavailableInEmbedded
    public static func _render<Renderer: _AsyncHTMLRendering>(
        _ html: consuming Self,
        into renderer: inout Renderer,
        with context: consuming _RenderingContext
    ) async throws {
        context.assertNoAttributes(self)

        for element in html._data {
            try await Content._render(html._contentBuilder(element), into: &renderer, with: copy context)
        }
    }
}

extension _ConditionalContent: _Renderable where TrueContent: _Renderable, FalseContent: _Renderable {
    @inlinable
    public static func _render<Renderer: _HTMLRendering>(
        _ html: consuming Self,
        into renderer: inout Renderer,
        with context: consuming _RenderingContext
    ) {
        switch html.value {
        case let .trueContent(content): return TrueContent._render(content, into: &renderer, with: context)
        case let .falseContent(content): return FalseContent._render(content, into: &renderer, with: context)
        }
    }

    @inlinable
    @_unavailableInEmbedded
    public static func _render<Renderer: _AsyncHTMLRendering>(
        _ html: consuming Self,
        into renderer: inout Renderer,
        with context: consuming _RenderingContext
    ) async throws {
        switch html.value {
        case let .trueContent(content): try await TrueContent._render(content, into: &renderer, with: context)
        case let .falseContent(content): try await FalseContent._render(content, into: &renderer, with: context)
        }
    }
}

extension _ArrayContent: _Renderable where Element: _Renderable {
    @inlinable
    public static func _render<Renderer: _HTMLRendering>(
        _ html: consuming Self,
        into renderer: inout Renderer,
        with context: consuming _RenderingContext
    ) {
        context.assertNoAttributes(self)

        for element in html.value {
            Element._render(element, into: &renderer, with: copy context)
        }
    }

    @inlinable
    @_unavailableInEmbedded
    public static func _render<Renderer: _AsyncHTMLRendering>(
        _ html: consuming Self,
        into renderer: inout Renderer,
        with context: consuming _RenderingContext
    ) async throws {
        context.assertNoAttributes(self)

        for element in html.value {
            try await Element._render(element, into: &renderer, with: copy context)
        }
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

extension _TupleContent6: _Renderable
where V0: _Renderable, V1: _Renderable, V2: _Renderable, V3: _Renderable, V4: _Renderable, V5: _Renderable {
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

#if !hasFeature(Embedded)
@_unavailableInEmbedded
extension AsyncContent: _Renderable where Content: _Renderable {
    @inlinable
    public static func _render<Renderer: _HTMLRendering>(
        _ html: consuming Self,
        into renderer: inout Renderer,
        with context: consuming _RenderingContext
    ) {
        context.assertionFailureNoAsyncContext(self)
    }

    @inlinable
    @_unavailableInEmbedded
    public static func _render<Renderer: _AsyncHTMLRendering>(
        _ html: consuming Self,
        into renderer: inout Renderer,
        with context: consuming _RenderingContext
    ) async throws {
        try await Content._render(await html.content(), into: &renderer, with: context)
    }
}

extension AsyncForEach: _Renderable where Content: _Renderable {
    @inlinable
    public static func _render<Renderer: _HTMLRendering>(
        _ html: consuming Self,
        into renderer: inout Renderer,
        with context: consuming _RenderingContext
    ) {
        context.assertionFailureNoAsyncContext(self)
    }

    @inlinable
    @_unavailableInEmbedded
    public static func _render<Renderer: _AsyncHTMLRendering>(
        _ html: consuming Self,
        into renderer: inout Renderer,
        with context: consuming _RenderingContext
    ) async throws {
        context.assertNoAttributes(self)

        for try await element in html.sequence {
            try await Content._render(html.contentBuilder(element), into: &renderer, with: copy context)
        }
    }
}

extension _ModifiedTaskLocal: _Renderable where Content: _Renderable {
    public static func _render<Renderer: _HTMLRendering>(
        _ html: consuming Self,
        into renderer: inout Renderer,
        with context: consuming _RenderingContext
    ) {
        html.taskLocal.withValue(html.value) { [context] in
            Content._render(html.wrappedContent, into: &renderer, with: context)
        }
    }

    @_unavailableInEmbedded
    public static func _render<Renderer: _AsyncHTMLRendering>(
        _ html: consuming Self,
        into renderer: inout Renderer,
        with context: consuming _RenderingContext
    ) async throws {
        try await html.taskLocal.withValue(html.value) { [context] in
            try await Content._render(html.wrappedContent, into: &renderer, with: context)
        }
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
#endif
#endif
