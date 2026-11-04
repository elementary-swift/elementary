/// A container that lazily builds content for each element in a sequence.
///
/// When its content is HTML, using `ForEach` instead of `for ... in` is potentially more efficient when rendering a
/// large number of elements, as the result does not need to be collected into an array before rendering.
///
/// ```swift
/// ForEach(1 ... 100) { index in
///    li { "Item \(index)" }
/// }
/// ```
public struct ForEach<Data, Content>
where Data: Sequence {
    /// The sequence of data to render.
    public var data: Data

    // TODO: Swift 6 - @Sendable is not ideal here, but currently the response generators for hummingbird/vapor require sendable HTML types
    // also, currently there is no good way to conditionally apply Sendable conformance based on closure type

    /// A closure that builds content for each element in the sequence.
    public var content: @Sendable (Data.Element) -> Content

    /// Creates a new `ForEach` container with the given sequence and content builder closure.
    ///
    /// - Parameters:
    ///   - data: A sequence of data to render.
    ///   - content: A closure that builds content for each element in the sequence.
    public init(_ data: Data, @ContentBuilder content: @escaping @Sendable (Data.Element) -> Content) {
        self.data = data
        self.content = content
    }
}

extension ForEach: Sendable where Data: Sendable {}

public extension ForEach {
    @available(*, deprecated, renamed: "data")
    var _data: Data {
        get { data }
        set { data = newValue }
    }

    @available(*, deprecated, renamed: "content")
    var _contentBuilder: @Sendable (Data.Element) -> Content {
        get { content }
        set { content = newValue }
    }
}
