#if !hasFeature(Embedded)
public extension HTML {
    /// Sets the value of a `TaskLocal` for the duration of rendering the content.
    ///
    /// The value can be accessed using the ``Environment`` property wrapper.
    /// Elementary uses task-locals as the underlying storage system for environment variables.
    ///
    /// ```swift
    /// enum Values {
    ///     @TaskLocal static var myNumber = 0
    /// }
    /// div {
    ///     MyNumber()
    ///         .environment(Values.$myNumber, 15)
    /// }
    /// ```
    func environment<T: Sendable>(_ taskLocal: TaskLocal<T>, _ value: T) -> _ModifiedTaskLocal<T, Self> {
        _ModifiedTaskLocal(wrappedContent: self, taskLocal: taskLocal, value: value)
    }
}
#endif
