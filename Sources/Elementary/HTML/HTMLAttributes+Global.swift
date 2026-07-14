/// A namespace for value types used in attributes.
public enum HTMLAttributeValue {}

// global attributes
public extension HTMLAttribute where Tag: HTMLTrait.Attributes.Global {
    static func title(_ value: String) -> Self {
        HTMLAttribute(name: "title", value: value)
    }

    static func lang(_ value: String) -> Self {
        HTMLAttribute(name: "lang", value: value)
    }

    static var hidden: Self {
        HTMLAttribute(name: "hidden", value: nil)
    }

    static func tabindex(_ index: Int) -> Self {
        HTMLAttribute(name: "tabindex", value: "\(index)")
    }

    static var popover: Self {
        HTMLAttribute(name: "popover", value: nil)
    }

    static func popover(_ popover: HTMLAttributeValue.Popover) -> Self {
        HTMLAttribute(name: "popover", value: popover.value)
    }

    static var inert: Self {
        HTMLAttribute(name: "inert", value: nil)
    }

    static func contenteditable(_ value: HTMLAttributeValue.ContentEditable) -> Self {
        HTMLAttribute(name: "contenteditable", value: value.value)
    }

    static func draggable(_ value: HTMLAttributeValue.Draggable) -> Self {
        HTMLAttribute(name: "draggable", value: value.value)
    }

    static func `is`(_ value: String) -> Self {
        HTMLAttribute(name: "is", value: value)
    }

    static func slot(_ value: String) -> Self {
        HTMLAttribute(name: "slot", value: value)
    }

    static var autofocus: Self {
        HTMLAttribute(name: "autofocus", value: nil)
    }

    static func dir(_ value: HTMLAttributeValue.Direction) -> Self {
        HTMLAttribute(name: "dir", value: value.value)
    }
}

// dir attribute
public extension HTMLAttributeValue {
    struct Direction: Sendable {
        let value: String

        public static var ltr: Self { .init(value: "ltr") }
        public static var rtl: Self { .init(value: "rtl") }
        public static var auto: Self { .init(value: "auto") }
    }
}

public extension HTMLAttributeValue {
    struct ContentEditable: Sendable {
        let value: String

        public static var `true`: Self { .init(value: "true") }
        public static var `false`: Self { .init(value: "false") }
        public static var plaintextOnly: Self { .init(value: "plaintext-only") }
    }
}

public extension HTMLAttributeValue {
    struct Popover: Sendable {
        let value: String

        public static var auto: Self { .init(value: "auto") }
        public static var hint: Self { .init(value: "hint") }
        public static var manual: Self { .init(value: "manual") }
    }
}

public extension HTMLAttributeValue {
    // MDN docs describe draggable as having an enumerated value, but currently
    // the only valid values are "true" and "false"
    struct Draggable: Sendable {
        let value: String

        public static var `true`: Self { .init(value: "true") }
        public static var `false`: Self { .init(value: "false") }
    }
}

public extension HTMLAttributeValue {
    typealias Role = MarkupAttributeValue.Role
}
