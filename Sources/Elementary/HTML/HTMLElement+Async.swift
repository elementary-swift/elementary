public extension MarkupElement where Self: MarkupContent, Tag: HTMLTrait.Paired {
    /// Creates a new paired markup element with the specified tag and async HTML content.
    ///
    /// The async content closure is automatically wrapped in an ``AsyncContent`` element and can only be rendered in an async context.
    ///
    /// - Parameters:
    ///   - attributes: The attributes to apply to the element.
    ///   - content: The future content of the element.
    @inlinable
    @_unavailableInEmbedded
    init<AwaitedContent: HTML>(
        _ attributes: HTMLAttribute<Tag>...,
        @ContentBuilder content: @escaping @Sendable () async throws -> AwaitedContent
    )
    where Self.Content == AsyncContent<AwaitedContent> {
        self._attributes = .init(attributes)
        self.content = AsyncContent(content: content)
    }

    /// Creates a new paired markup element with the specified tag and async HTML content.
    ///
    /// The async content closure is automatically wrapped in an ``AsyncContent`` element and can only be rendered in an async context.
    ///
    /// - Parameters:
    ///   - attributes: The attributes to apply to the element.
    ///   - content: The future content of the element.
    @inlinable
    @_unavailableInEmbedded
    init<AwaitedContent: HTML>(
        attributes: [HTMLAttribute<Tag>],
        @ContentBuilder content: @escaping @Sendable () async throws -> AwaitedContent
    )
    where Self.Content == AsyncContent<AwaitedContent> {
        self._attributes = .init(attributes)
        self.content = AsyncContent(content: content)
    }
}
