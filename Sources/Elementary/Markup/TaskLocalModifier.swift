#if !hasFeature(Embedded)
/// A modifier that scopes a task-local value to rendering its content.
///
/// ``MarkupContent/taskLocalValue(_:_:)`` creates this modifier automatically.
/// The scoped value is available during synchronous and asynchronous rendering.
/// The previous value is restored when rendering finishes, including when it throws.
/// `WrappedContent` identifies the content this modifier is attached to.
public struct _TaskLocalModifier<T: Sendable, WrappedContent>: Sendable {
    /// The task-local storage whose value is overridden during rendering.
    public var taskLocal: TaskLocal<T>

    /// The value made available while rendering the wrapped content.
    public var value: T

    /// Creates a modifier that provides the specified task-local value.
    @inlinable
    public init(taskLocal: TaskLocal<T>, value: T) {
        self.taskLocal = taskLocal
        self.value = value
    }
}

extension _TaskLocalModifier: _MarkupRenderingModifier where WrappedContent: MarkupContent {
    public typealias InputTag = WrappedContent.Tag
    public typealias Tag = WrappedContent.Tag
}

/// Compatibility alias for task-local-modified content.
@available(*, deprecated, renamed: "ModifiedContent")
public typealias _ModifiedTaskLocal<T: Sendable, Content> = ModifiedContent<Content, _TaskLocalModifier<T, Content>>
#endif
