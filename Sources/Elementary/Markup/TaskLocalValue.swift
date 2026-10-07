#if !hasFeature(Embedded)
/// A property wrapper that reads a task-local value from a `TaskLocal`.
///
/// Use `@TaskLocalValue` to conveniently read a value provided via ``HTML/taskLocalValue(_:_:)``.
/// The value is read from the current task each time the property is accessed.
///
/// ```swift
/// enum Values {
///     @TaskLocal static var myNumber = 0
/// }
/// struct MyNumber: HTML {
///     @TaskLocalValue(Values.$myNumber) var number
///
///     var body: some HTML {
///         p { "\(number)" }
///     }
/// }
/// ```
@propertyWrapper
public struct TaskLocalValue<T: Sendable>: Sendable {
    enum _Storage {
        case taskLocal(TaskLocal<T>)
        case optionalTaskLocal(TaskLocal<T?>)
    }

    var storage: _Storage

    /// Creates a task-local property that reads the value from the given `TaskLocal`.
    /// - Parameter taskLocal: The `TaskLocal` to read the value from.
    public init(_ taskLocal: TaskLocal<T>) {
        storage = .taskLocal(taskLocal)
    }

    /// Creates a task-local property that reads the value from the given `TaskLocal`
    /// by force-unwrapping an optional.
    ///
    /// Note: If the value is `nil` during rendering, execution terminates with a fatal error.
    /// - Parameter taskLocal: The `TaskLocal` to read the value from.
    public init(requiring taskLocal: TaskLocal<T?>) {
        storage = .optionalTaskLocal(taskLocal)
    }

    /// The value of the task-local property.
    public var wrappedValue: T {
        switch storage {
        case let .taskLocal(taskLocal): return taskLocal.wrappedValue
        case let .optionalTaskLocal(taskLocal):
            guard let value = taskLocal.wrappedValue else {
                fatalError("No value set for \(T.self) in \(taskLocal)")
            }

            return value
        }
    }
}

/// Compatibility alias for ``TaskLocalValue``.
@available(*, deprecated, renamed: "TaskLocalValue")
public typealias Environment<T: Sendable> = TaskLocalValue<T>

public struct _ModifiedTaskLocal<T: Sendable, Content> {
    var wrappedContent: Content
    var taskLocal: TaskLocal<T>
    var value: T
}

extension _ModifiedTaskLocal: Sendable where Content: Sendable {}
#endif
