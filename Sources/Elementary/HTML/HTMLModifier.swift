/// A reusable transformation of HTML content.
///
/// The default input tag, `Never`, accepts any HTML through an erased placeholder.
/// Declare a concrete input tag or a generic tag constrained by HTML traits to
/// access element-specific attributes in ``body(content:)``. The resulting tag
/// is the tag of ``Body``.
///
/// ```swift
/// struct Card: HTMLModifier {
///     func body(content: Content) -> some HTML<HTMLTag.div> {
///         div(.class("card")) { content }
///     }
/// }
/// p { "Hello" }.modifier(Card())
/// ```
///
/// A typed modifier can declare `typealias InputTag = HTMLTag.p`, or use a generic
/// parameter and declare `typealias InputTag = T`. Application then requires the
/// content's tag to match that input tag.
public protocol HTMLModifier<InputTag>: _MarkupRenderingModifier where Tag == Body.Tag {
    /// The accepted input tag; `Never` opts into untyped application.
    associatedtype InputTag: HTMLTagDefinition = Never

    /// The HTML produced by this modifier.
    associatedtype Body: HTML

    /// The placeholder representing the content supplied to the modifier.
    typealias Content = _HTMLModifierContent<InputTag>

    /// Creates the HTML produced by applying this modifier to its input.
    @ContentBuilder func body(content: Content) -> Body
}

public extension HTMLModifier {
    /// The default input tag for modifiers that accept arbitrary HTML.
    // This default witness also lets conformers resolve Content before inferring
    // Body. An associated-type default alone does not resolve that inference cycle.
    typealias InputTag = Never
}

public extension HTML {
    /// Applies a modifier whose input tag matches this content's tag directly.
    @inlinable
    func modifier<Modifier: HTMLModifier>(_ modifier: Modifier) -> ModifiedContent<Self, Modifier>
    where Modifier.InputTag == Tag {
        ModifiedContent(content: self, modifier: modifier)
    }

    /// Applies an untyped modifier using an adapter for this content's tag.
    ///
    /// When both input tags are statically known to be `Never`, the direct
    /// overload is preferred.
    @inlinable
    @_disfavoredOverload
    func modifier<Modifier: HTMLModifier>(
        _ modifier: Modifier
    ) -> ModifiedContent<Self, _AppliedHTMLModifier<Self, Modifier>>
    where Modifier.InputTag == Never {
        ModifiedContent(content: self, modifier: .init(modifier))
    }
}

/// The input placeholder passed to an HTML modifier's body.
///
/// The placeholder renders the original content and exposes the attributes
/// supported by its tag. A `Never` tag exposes no element-specific attributes.
/// It can be rendered multiple times, but is not `Sendable` because the original
/// content need not be `Sendable`.
public struct _HTMLModifierContent<Tag: HTMLTagDefinition> {
    #if !hasFeature(Embedded)
    @usableFromInline
    let content: any _Renderable

    @usableFromInline
    init<Content: MarkupContent>(_ content: consuming Content) where Content.Tag == Tag {
        self.content = content
    }
    #endif
}

#if !hasFeature(Embedded)
extension _HTMLModifierContent where Tag == Never {
    @usableFromInline
    init<Content: MarkupContent>(erasing content: consuming Content) {
        self.content = content
    }
}
#endif

/// An adapter that applies an untyped HTML modifier to tagged content.
///
/// ``HTML/modifier(_:)`` creates this adapter when the modifier's input tag is
/// `Never` and the wrapped content has a different tag. Its input tag matches the
/// wrapped content; its resulting tag is the tag of the modifier's body.
public struct _AppliedHTMLModifier<WrappedContent: HTML, Modifier: HTMLModifier>: _MarkupRenderingModifier
where Modifier.InputTag == Never {
    public typealias InputTag = WrappedContent.Tag
    public typealias Tag = Modifier.Body.Tag

    @usableFromInline
    var modifier: Modifier

    @usableFromInline
    init(_ modifier: Modifier) {
        self.modifier = modifier
    }
}

extension _AppliedHTMLModifier: Sendable where Modifier: Sendable {}
