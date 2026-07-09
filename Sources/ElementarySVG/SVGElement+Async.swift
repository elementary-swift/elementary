import Elementary

#if !hasFeature(Embedded)
public extension MarkupElement where Tag: SVGTagDefinition {
    /// Creates a new SVG element with the specified tag and async content.
    ///
    /// The async content closure is automatically wrapped in an ``AsyncContent`` element and can only be rendered in an async context.
    ///
    /// - Parameters:
    ///   - attributes: The attributes to apply to the element.
    ///   - content: The future content of the element.
    @inlinable
    @_unavailableInEmbedded
    init<AwaitedContent: SVGContent>(
        _ attributes: SVGAttribute<Tag>...,
        @ContentBuilder content: @escaping @Sendable () async throws -> AwaitedContent
    )
    where Self.Content == AsyncContent<AwaitedContent> {
        self.init(attributes: attributes) {
            AsyncContent(content: content)
        }
    }

    /// Creates a new SVG element with the specified tag and async content.
    ///
    /// The async content closure is automatically wrapped in an ``AsyncContent`` element and can only be rendered in an async context.
    ///
    /// - Parameters:
    ///   - attributes: The attributes to apply to the element.
    ///   - content: The future content of the element.
    @inlinable
    @_unavailableInEmbedded
    init<AwaitedContent: SVGContent>(
        attributes: [SVGAttribute<Tag>],
        @ContentBuilder content: @escaping @Sendable () async throws -> AwaitedContent
    )
    where Self.Content == AsyncContent<AwaitedContent> {
        self.init(attributes: attributes) {
            AsyncContent(content: content)
        }
    }
}

public extension SVGRoot {
    /// Creates a new root SVG element with the specified tag and async content.
    ///
    /// The async content closure is automatically wrapped in an ``AsyncContent`` element and can only be rendered in an async context.
    ///
    /// - Parameters:
    ///   - attributes: The attributes to apply to the element.
    ///   - content: The future content of the element.
    @inlinable
    @_unavailableInEmbedded
    init<AwaitedContent: SVGContent>(
        _ attributes: SVGAttribute<SVGTag.svg>...,
        @ContentBuilder content: @escaping @Sendable () async throws -> AwaitedContent
    )
    where Self.Content == AsyncContent<AwaitedContent> {
        self.init(attributes: attributes) {
            AsyncContent(content: content)
        }
    }

    /// Creates a new root SVG element with the specified tag and async content.
    ///
    /// The async content closure is automatically wrapped in an ``AsyncContent`` element and can only be rendered in an async context.
    ///
    /// - Parameters:
    ///   - attributes: The attributes to apply to the element.
    ///   - content: The future content of the element.
    @inlinable
    @_unavailableInEmbedded
    init<AwaitedContent: SVGContent>(
        attributes: [SVGAttribute<SVGTag.svg>],
        @ContentBuilder content: @escaping @Sendable () async throws -> AwaitedContent
    )
    where Self.Content == AsyncContent<AwaitedContent> {
        self.init(attributes: attributes) {
            AsyncContent(content: content)
        }
    }
}
#endif
