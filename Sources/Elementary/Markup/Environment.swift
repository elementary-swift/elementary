#if !hasFeature(Embedded)
/// A property wrapper that reads an environment value from a `TaskLocal`.
///
/// Use `@Environment` to conveniently read a value provided via ``HTML/environment(_:_:)``.
/// Elementary uses task-locals as the underlying storage system for environment variables.
///
/// ```swift
/// enum Values {
///     @TaskLocal static var myNumber = 0
/// }
/// struct MyNumber: HTML {
///     @Environment(Values.$myNumber) var number
///
///     var body: some HTML {
///         p { "\(number)" }
///     }
/// }
/// ```
@propertyWrapper
public struct Environment<T: Sendable>: Sendable {
    enum _Storage {
        case taskLocal(TaskLocal<T>)
        case optionalTaskLocal(TaskLocal<T?>)
    }

    var storage: _Storage

    /// Creates an environment property that reads the value from the given `TaskLocal`.
    /// - Parameter taskLocal: The `TaskLocal` to read the value from.
    public init(_ taskLocal: TaskLocal<T>) {
        storage = .taskLocal(taskLocal)
    }

    /// Creates an environment property that reads the value from the given `TaskLocal`
    /// by force-unwrapping an optional.
    ///
    /// Note: Is the value is `nil` during rendering, a fatal error will be thrown.
    /// - Parameter taskLocal: The `TaskLocal` to read the value from.
    public init(requiring taskLocal: TaskLocal<T?>) {
        storage = .optionalTaskLocal(taskLocal)
    }

    /// The value of the environment property.
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

public struct _ModifiedTaskLocal<T: Sendable, Content> {
    var wrappedContent: Content
    var taskLocal: TaskLocal<T>
    var value: T
}

extension _ModifiedTaskLocal: Sendable where Content: Sendable {}
#endif
