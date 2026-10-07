#if !hasFeature(Embedded)
public extension HTML {
    /// Sets the value of a `TaskLocal` for the duration of rendering the content.
    ///
    /// The value can be accessed using the ``TaskLocalValue`` property wrapper.
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
    func taskLocalValue<T: Sendable>(_ taskLocal: TaskLocal<T>, _ value: T) -> _ModifiedTaskLocal<T, Self> {
        _ModifiedTaskLocal(wrappedContent: self, taskLocal: taskLocal, value: value)
    }

    /// Compatibility modifier for ``taskLocalValue(_:_:)``.
    @available(*, deprecated, renamed: "taskLocalValue(_:_:)")
    func environment<T: Sendable>(_ taskLocal: TaskLocal<T>, _ value: T) -> _ModifiedTaskLocal<T, Self> {
        taskLocalValue(taskLocal, value)
    }
}
#endif
