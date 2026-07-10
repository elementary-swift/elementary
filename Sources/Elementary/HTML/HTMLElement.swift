/// An HTML element that can contain content.
public struct HTMLElement<Tag: HTMLTrait.Paired, Content: HTML>: _Attributed, HTML {
    public typealias Body = Never

    public var _attributes: _AttributeStorage

    /// The content of the element.
    public var content: Content

    /// Creates a new HTML element with the specified content.
    @inlinable
    public init(@ContentBuilder content: () -> Content) {
        self._attributes = .init()
        self.content = content()
    }

    /// Creates a new HTML element with the specified attribute and content.
    @inlinable
    public init(_ attribute: MarkupAttribute<Tag>, @ContentBuilder content: () -> Content) {
        self._attributes = .init(attribute)
        self.content = content()
    }

    /// Creates a new HTML element with the specified attributes and content.
    @inlinable
    public init(_ attributes: MarkupAttribute<Tag>..., @ContentBuilder content: () -> Content) {
        self._attributes = .init(attributes)
        self.content = content()
    }

    /// Creates a new HTML element with the specified attributes and content.
    @inlinable
    public init(attributes: [MarkupAttribute<Tag>], @ContentBuilder content: () -> Content) {
        self._attributes = .init(attributes)
        self.content = content()
    }
}

public extension HTMLElement where Content == EmptyContent {
    /// Creates a new empty HTML element.
    @inlinable
    init() {
        self._attributes = .init()
        self.content = EmptyContent()
    }

    /// Creates a new empty HTML element with the specified attribute.
    @inlinable
    init(_ attribute: MarkupAttribute<Tag>) {
        self._attributes = .init(attribute)
        self.content = EmptyContent()
    }

    /// Creates a new empty HTML element with the specified attributes.
    @inlinable
    init(_ attributes: MarkupAttribute<Tag>...) {
        self._attributes = .init(attributes)
        self.content = EmptyContent()
    }

    /// Creates a new empty HTML element with the specified attributes.
    @inlinable
    init(attributes: [MarkupAttribute<Tag>]) {
        self._attributes = .init(attributes)
        self.content = EmptyContent()
    }
}

#if !hasFeature(Embedded)
public extension HTMLElement {
    /// Creates a new HTML element with async content.
    @inlinable
    @_unavailableInEmbedded
    init<AwaitedContent: HTML>(
        _ attributes: MarkupAttribute<Tag>...,
        @ContentBuilder content: @escaping @Sendable () async throws -> AwaitedContent
    )
    where Content == AsyncContent<AwaitedContent> {
        self._attributes = .init(attributes)
        self.content = AsyncContent(content: content)
    }

    /// Creates a new HTML element with async content.
    @inlinable
    @_unavailableInEmbedded
    init<AwaitedContent: HTML>(
        attributes: [MarkupAttribute<Tag>],
        @ContentBuilder content: @escaping @Sendable () async throws -> AwaitedContent
    )
    where Content == AsyncContent<AwaitedContent> {
        self._attributes = .init(attributes)
        self.content = AsyncContent(content: content)
    }
}
#endif

extension HTMLElement: Sendable where Content: Sendable {}
