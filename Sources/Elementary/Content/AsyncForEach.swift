#if !hasFeature(Embedded)
/// A container that lazily builds content for each element of an `AsyncSequence`.
///
/// When its content is HTML, this element can only be rendered in an async context (ie: by calling
/// ``HTML/render(into:chunkSize:)`` or ``HTML/renderAsync()``).
///
/// ```swift
/// ul {
///   let users = try await db.users.findAll()
///   AsyncForEach(users) { user in
///     li { "\(user.name) \(user.favoriteProgrammingLanguage)" }
///   }
/// }
/// ```
public struct AsyncForEach<Source: AsyncSequence, Content> {
    /// The async sequence of data to render.
    public var data: Source

    /// A closure that builds content for each element in the sequence.
    public var content: (Source.Element) -> Content

    /// Creates a new async container that builds the specified content for each element of the sequence.
    ///
    /// - Parameters:
    ///   - data: An `AsyncSequence` of data to render.
    ///   - content: A closure that builds content for each element in the sequence.
    public init(_ data: Source, @ContentBuilder content: @escaping (Source.Element) -> Content) {
        self.data = data
        self.content = content
    }
}

public extension AsyncForEach {
    @available(*, deprecated, renamed: "init(_:content:)")
    @_disfavoredOverload
    init(_ sequence: Source, @ContentBuilder contentBuilder: @escaping (Source.Element) -> Content) {
        self.init(sequence, content: contentBuilder)
    }
}
#endif
