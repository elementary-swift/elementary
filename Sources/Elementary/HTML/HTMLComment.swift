/// A type that represents an HTML comment.
///
/// A comment is rendered as `<!--text-->` and the text will be escaped if necessary.
public struct HTMLComment: HTML {
    public typealias Tag = Never
    public typealias Body = Never

    /// The text of the comment.
    public var text: String

    /// Creates a new HTML comment with the specified text.
    public init(_ text: String) {
        self.text = text
    }
}

extension HTMLComment: Sendable {}
