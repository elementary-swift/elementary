#if !hasFeature(Embedded)
public extension MarkupContent {
    /// Sets the value of a `TaskLocal` for the duration of rendering the content.
    ///
    /// The value can be accessed using the ``TaskLocalValue`` property wrapper.
    /// The previous value is restored when rendering finishes or throws.
    /// This method supports both HTML and SVG content.
    ///
    /// - Parameters:
    ///   - taskLocal: The task-local storage to override.
    ///   - value: The value to provide while rendering.
    /// - Returns: The content paired with a task-local modifier.
    ///
    /// ```swift
    /// enum Values {
    ///     @TaskLocal static var myNumber = 0
    /// }
    /// div {
    ///     MyNumber()
    ///         .taskLocalValue(Values.$myNumber, 15)
    /// }
    /// ```
    @inlinable
    func taskLocalValue<T: Sendable>(_ taskLocal: TaskLocal<T>, _ value: T) -> ModifiedContent<Self, _TaskLocalModifier<T, Self>> {
        ModifiedContent(content: self, modifier: .init(taskLocal: taskLocal, value: value))
    }

    /// Compatibility modifier for ``taskLocalValue(_:_:)``.
    @available(*, deprecated, renamed: "taskLocalValue(_:_:)")
    @inlinable
    func environment<T: Sendable>(_ taskLocal: TaskLocal<T>, _ value: T) -> ModifiedContent<Self, _TaskLocalModifier<T, Self>> {
        taskLocalValue(taskLocal, value)
    }
}
#endif
