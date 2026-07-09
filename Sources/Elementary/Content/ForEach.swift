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
    public var _data: Data
    // TODO: Swift 6 - @Sendable is not ideal here, but currently the response generators for hummingbird/vapor require sendable HTML types
    // also, currently there is no good way to conditionally apply Sendable conformance based on closure type

    public var _contentBuilder: @Sendable (Data.Element) -> Content

    /// Creates a new `ForEach` container with the given sequence and content builder closure.
    ///
    /// - Parameters:
    ///  - sequence: A sequence of data to render.
    ///  - contentBuilder: A closure that builds content for each element in the sequence.
    public init(_ data: Data, @ContentBuilder content contentBuilder: @escaping @Sendable (Data.Element) -> Content) {
        _data = data
        _contentBuilder = contentBuilder
    }
}

extension ForEach: Sendable where Data: Sendable {}
