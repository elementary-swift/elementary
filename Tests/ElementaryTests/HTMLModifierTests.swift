import Elementary
import Testing

struct HTMLModifierTests {
    @Test func wildcardModifierWorksAcrossTags() async throws {
        let card = Card()
        let paragraph = p { "hello" }.modifier(card)
        let field = input().modifier(card)
        requireAdapted(paragraph, card)
        requireAdapted(field, card)
        requireResultTag(paragraph, HTMLTag.div.self)
        try await HTMLAssertEqual(paragraph, "<div class=\"card\"><p>hello</p></div>")
        try await HTMLAssertEqual(field, "<div class=\"card\"><input></div>")
        try await HTMLAssertEqual(ModifierParagraph().modifier(card), "<div class=\"card\"><p>custom</p></div>")
        try await HTMLAssertEqual(SVG.svg {}.modifier(card), "<div class=\"card\"><svg /></div>")
    }

    @Test func neverToNeverUsesDirectModifier() async throws {
        let modifier = Card()
        let content = StringContent("hello").modifier(modifier)
        requireDirect(content, modifier)
        requireResultTag(content, HTMLTag.div.self)
        try await HTMLAssertEqual(content, "<div class=\"card\">hello</div>")
        let group = Group {
            p { "one" }; p { "two" }
        }.modifier(modifier)
        requireDirect(group, modifier)
        try await HTMLAssertEqual(group, "<div class=\"card\"><p>one</p><p>two</p></div>")
    }

    @Test func matchingTypedTagsUseDirectModifier() async throws {
        let modifier = TypedCard<HTMLTag.p>()
        let content = p { "hello" }.modifier(modifier)
        requireDirect(content, modifier)
        requireResultTag(content, HTMLTag.div.self)
        try await HTMLAssertEqual(content, "<div><p>hello</p></div>")
        let custom = ModifierParagraph().modifier(modifier)
        requireDirect(custom, modifier)
        try await HTMLAssertEqual(custom, "<div><p>custom</p></div>")
    }

    @Test func traitConstrainedModifierPreservesTagAndAddsAttributes() async throws {
        let field = input().modifier(Hint())
        requireDirect(field, Hint<HTMLTag.input>())
        requireResultTag(field, HTMLTag.input.self)
        try await HTMLAssertEqual(field, "<input placeholder=\"Hint\">")
        let area = textarea { "message" }.modifier(Hint())
        requireDirect(area, Hint<HTMLTag.textarea>())
        requireResultTag(area, HTMLTag.textarea.self)
        try await HTMLAssertEqual(area, "<textarea placeholder=\"Hint\">message</textarea>")
    }

    @Test func attributesAndTaskLocalsComposeWithBodyModifiers() async throws {
        let html = ModifierNumber()
            .attributes(.id("child"))
            .modifier(Card())
            .attributes(.id("wrapper"))
            .taskLocalValue(HTMLModifierValues.$number, 7)
        try await HTMLAssertEqual(html, "<div class=\"card\" id=\"wrapper\"><p id=\"child\">7</p></div>")
        #expect(HTMLModifierValues.number == 0)
    }

    @Test func placeholderCanRenderMultipleTimes() async throws {
        try await HTMLAssertEqual(p { "again" }.modifier(Duplicate()), "<div><p>again</p><p>again</p></div>")
    }

    @Test func asyncContentAndThrowingWriterRestoreTaskLocal() async throws {
        let html = AsyncContent {
            await Task.yield()
            return p { String(HTMLModifierValues.number) }
        }.modifier(Card()).taskLocalValue(HTMLModifierValues.$number, 9)
        #expect(try await html.renderAsync() == "<div class=\"card\"><p>9</p></div>")
        do {
            try await html.render(into: FailingModifierWriter(), chunkSize: 1)
            Issue.record("Expected writer failure")
        } catch {
            #expect(error is ModifierFailure)
        }
        #expect(HTMLModifierValues.number == 0)
    }

    @Test func wildcardAdapterHonorsRenderingWitness() async throws {
        let modifier = CustomRenderingModifier()
        let direct = StringContent("direct").modifier(modifier)
        let adapted = p { "adapted" }.modifier(modifier)
        requireDirect(direct, modifier)
        requireAdapted(adapted, modifier)
        try await HTMLAssertEqual(direct, "<div>custom rendering</div>")
        try await HTMLAssertEqual(adapted, "<div>custom rendering</div>")
    }

    @Test func publicInlinableConstruction() {
        let result = applyFixtureCard(p { "hello" })
        requireAdapted(result, Card())
    }
}

private struct Card: HTMLModifier {
    func body(content: Content) -> some HTML<HTMLTag.div> {
        div(.class("card")) { content }
    }
}

private struct TypedCard<T: HTMLTagDefinition>: HTMLModifier {
    typealias InputTag = T
    func body(content: Content) -> some HTML<HTMLTag.div> {
        div { content }
    }
}

private struct Hint<T: HTMLTagDefinition>: HTMLModifier
where T: HTMLTrait.Attributes.placeholder & MarkupTrait.AllowsAttributes {
    typealias InputTag = T
    func body(content: Content) -> some HTML<InputTag> {
        content.attributes(.placeholder("Hint"))
    }
}

private struct Duplicate: HTMLModifier {
    func body(content: Content) -> some HTML<HTMLTag.div> {
        div {
            content; content
        }
    }
}

private struct ModifierParagraph: HTML {
    var body: some HTML<HTMLTag.p> { p { "custom" } }
}

private enum HTMLModifierValues {
    @TaskLocal static var number = 0
}

private struct ModifierNumber: HTML {
    var body: some HTML<HTMLTag.p> { p { String(HTMLModifierValues.number) } }
}

private struct ModifierFailure: Error {}
private struct FailingModifierWriter: HTMLStreamWriter {
    mutating func write(_ bytes: ArraySlice<UInt8>) async throws { throw ModifierFailure() }
}

private func requireDirect<C, M>(_ content: ModifiedContent<C, M>, _ modifier: M) {}
private func requireAdapted<C: HTML, M: HTMLModifier>(
    _ content: ModifiedContent<C, _AppliedHTMLModifier<C, M>>,
    _ modifier: M
) where M.InputTag == Never {}
private func requireResultTag<C: MarkupContent>(_ content: C, _ tag: C.Tag.Type) {}

@inlinable
func applyFixtureCard<C: HTML, M: HTMLModifier>(
    _ content: C,
    _ modifier: M
) -> ModifiedContent<C, _AppliedHTMLModifier<C, M>> where M.InputTag == Never {
    content.modifier(modifier)
}

private func applyFixtureCard<C: HTML>(_ content: C) -> ModifiedContent<C, _AppliedHTMLModifier<C, Card>> {
    applyFixtureCard(content, Card())
}

private struct CustomRenderingModifier: HTMLModifier {
    func body(content: Content) -> some HTML<HTMLTag.div> {
        div { "body fallback" }
    }

    consuming func _render<WrappedContent: MarkupContent, Renderer: _HTMLRendering>(
        _ content: consuming WrappedContent,
        into renderer: inout Renderer,
        with context: consuming _RenderingContext
    ) where WrappedContent.Tag == InputTag {
        let replacement = div { "custom rendering" }
        type(of: replacement)._render(replacement, into: &renderer, with: context)
    }

    consuming func _render<WrappedContent: MarkupContent, Renderer: _AsyncHTMLRendering>(
        _ content: consuming WrappedContent,
        into renderer: inout Renderer,
        with context: consuming _RenderingContext
    ) async throws where WrappedContent.Tag == InputTag {
        let replacement = div { "custom rendering" }
        try await type(of: replacement)._render(replacement, into: &renderer, with: context)
    }
}
