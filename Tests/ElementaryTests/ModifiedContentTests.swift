import Elementary
import Testing

struct ModifiedContentTests {
    @Test func unconstrainedMutableStorage() {
        var value = ModifiedContent(content: 1, modifier: "first")
        value.content = 2
        value.modifier = "second"
        #expect(value.content == 2)
        #expect(value.modifier == "second")
        requireSendable(value)
    }

    @Test func modifiersPreserveNamespacesAndTags() async throws {
        let html = ModifiedHTML().attributes(.id("html"))
        requireHTML(html)
        requireTag(html, HTMLTag.p.self)
        requireSendable(html)
        try await HTMLAssertEqual(html, "<p id=\"html\">0</p>")

        let svg = ModifiedSVG().attributes(.id("svg")).taskLocalValue(ModifierValues.$number, 7)
        requireSVG(svg)
        requireTag(svg, SVGTag.text.self)
        requireSendable(svg)
        try await HTMLAssertEqual(SVG.svg { svg }, "<svg><text id=\"svg\">7</text></svg>")
    }

    @Test func mixedModifierOrderAndRepeatedAttributes() async throws {
        let first = ModifiedHTML()
            .attributes(.class("first"))
            .taskLocalValue(ModifierValues.$number, 1)
            .attributes(.class("second"))
            .attributes(.id("value"))
        try await HTMLAssertEqual(first, "<p class=\"first second\" id=\"value\">1</p>")
        let second = ModifiedHTML()
            .taskLocalValue(ModifierValues.$number, 2)
            .attributes(.class("first"))
            .attributes(.class("second"))
        try await HTMLAssertEqual(second, "<p class=\"first second\">2</p>")
        #expect(ModifierValues.number == 0)
    }

    @Test func svgTaskLocalSurvivesSuspension() async throws {
        let svg = AsyncContent {
            let number = await svgNumberAfterSuspension()
            SVG.text { number }
        }.taskLocalValue(ModifierValues.$number, 9)
        try await HTMLAssertEqualAsyncOnly(SVG.svg { svg }, "<svg><text>9</text></svg>")
        #expect(ModifierValues.number == 0)
    }

    @Test func mutableModifierStorageAffectsRendering() async throws {
        var content = ModifiedHTML().taskLocalValue(ModifierValues.$number, 1)
        content.modifier.value = 4
        var attributed = content.attributes(.id("first"))
        attributed.modifier._attributes = .init(.id("second") as HTMLAttribute<HTMLTag.p>)
        try await HTMLAssertEqual(attributed, "<p id=\"second\">4</p>")
    }

    @Test func nativeAndRepeatedAttributesKeepTheirTypes() {
        let native = p {}.attributes(.id("native"))
        requireSameType(native, p {})
        let wrapped = ModifiedHTML().attributes(.id("first"))
        requireSameType(wrapped, wrapped.attributes(.class("second")))
    }

    @Test func taskLocalRestoresAfterSuspensionAndFailure() async {
        enum Failure: Error { case expected }
        let content = AsyncContent {
            await Task.yield()
            #expect(ModifierValues.number == 2)
            try failRendering(Failure.expected)
            return p {}
        }.taskLocalValue(ModifierValues.$number, 2)
            .taskLocalValue(ModifierValues.$number, 1)
        do {
            _ = try await content.renderAsync()
            Issue.record("Expected rendering to throw")
        } catch {
            #expect(error is Failure)
        }
        #expect(ModifierValues.number == 0)
    }

    @Test func customModifierDelegatesRendering() async throws {
        let content = ModifiedContent(content: ModifiedHTML(), modifier: TestMarkupModifier())
        try await HTMLAssertEqual(content, "<p>0</p>")
    }

    @Test func modifierDefinesResultTag() async throws {
        let content = ModifiedContent(content: ModifiedHTML(), modifier: ReplacementModifier())
        requireTag(content, HTMLTag.div.self)
        requireHTML(content)
        try await HTMLAssertEqual(content, "<div></div>")
    }

    @Test func legacyAliasesAndMutableMembers() async throws {
        var empty = _AttributedContent(content: ModifiedHTML())
        empty.content = ModifiedHTML()
        empty._attributes = .init(.id("empty") as HTMLAttribute<HTMLTag.p>)
        let single = _AttributedContent(content: ModifiedHTML(), attribute: .id("single"))
        let array = _AttributedContent(content: ModifiedHTML(), attributes: [.id("array")])
        let storage = _AttributedContent(
            content: ModifiedHTML(),
            attributes: _AttributeStorage(.id("storage") as HTMLAttribute<HTMLTag.p>)
        )
        var element: _AttributedElement<ModifiedHTML> = empty
        element.attributes = .init(.id("element") as HTMLAttribute<HTMLTag.p>)
        let taskLocal: _ModifiedTaskLocal<Int, ModifiedHTML> = ModifiedHTML().taskLocalValue(ModifierValues.$number, 3)
        try await HTMLAssertEqual(empty, "<p id=\"empty\">0</p>")
        try await HTMLAssertEqual(single, "<p id=\"single\">0</p>")
        try await HTMLAssertEqual(array, "<p id=\"array\">0</p>")
        try await HTMLAssertEqual(storage, "<p id=\"storage\">0</p>")
        try await HTMLAssertEqual(element, "<p id=\"element\">0</p>")
        try await HTMLAssertEqual(taskLocal, "<p>3</p>")
        try await HTMLAssertEqual(
            ModifiedHTML().environment(ModifierValues.$number, 5),
            "<p>5</p>"
        )
    }
}

private enum ModifierValues {
    @TaskLocal static var number = 0
}

private struct ModifiedHTML: HTML, Sendable {
    var body: some HTML<HTMLTag.p> { p { String(ModifierValues.number) } }
}

private struct ModifiedSVG: SVGContent, Sendable {
    var body: some SVGContent<SVGTag.text> { SVG.text { String(ModifierValues.number) } }
}

private func requireSendable<T: Sendable>(_ value: T) {}
private func requireHTML<T: HTML>(_ value: T) {}
private func requireSVG<T: SVGContent>(_ value: T) {}
private func requireTag<T: MarkupContent>(_ value: T, _ tag: T.Tag.Type) {}
private func requireSameType<T>(_ first: T, _ second: T) {}

private struct TestMarkupModifier: _MarkupRenderingModifier {
    typealias InputTag = HTMLTag.p
    typealias Tag = HTMLTag.p

    consuming func _render<Content: MarkupContent, Renderer: _HTMLRendering>(
        _ content: consuming Content,
        into renderer: inout Renderer,
        with context: consuming _RenderingContext
    ) where Content.Tag == InputTag {
        Content._render(content, into: &renderer, with: context)
    }

    consuming func _render<Content: MarkupContent, Renderer: _AsyncHTMLRendering>(
        _ content: consuming Content,
        into renderer: inout Renderer,
        with context: consuming _RenderingContext
    ) async throws where Content.Tag == InputTag {
        try await Content._render(content, into: &renderer, with: context)
    }
}

private func failRendering(_ error: any Error) throws { throw error }

private func svgNumberAfterSuspension() async -> String {
    await Task.yield()
    return String(ModifierValues.number)
}

private struct ReplacementModifier: _MarkupRenderingModifier {
    typealias InputTag = HTMLTag.p
    typealias Tag = HTMLTag.div

    consuming func _render<Content: MarkupContent, Renderer: _HTMLRendering>(
        _ content: consuming Content,
        into renderer: inout Renderer,
        with context: consuming _RenderingContext
    ) where Content.Tag == InputTag {
        let replacement = div {}
        type(of: replacement)._render(replacement, into: &renderer, with: context)
    }

    consuming func _render<Content: MarkupContent, Renderer: _AsyncHTMLRendering>(
        _ content: consuming Content,
        into renderer: inout Renderer,
        with context: consuming _RenderingContext
    ) async throws where Content.Tag == InputTag {
        let replacement = div {}
        try await type(of: replacement)._render(replacement, into: &renderer, with: context)
    }
}
