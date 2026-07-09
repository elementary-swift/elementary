/// A type that represents markup content that can be rendered.
///
/// This protocol contains the namespace-neutral rendering machinery shared by HTML and SVG.
public protocol _Renderable {
    static func _render<Renderer: _HTMLRendering>(
        _ html: consuming Self,
        into renderer: inout Renderer,
        with context: consuming _RenderingContext
    )

    #if !hasFeature(Embedded)
    static func _render<Renderer: _AsyncHTMLRendering>(
        _ html: consuming Self,
        into renderer: inout Renderer,
        with context: consuming _RenderingContext
    ) async throws
    #endif
}

/// A type that represents namespace-neutral markup content.
///
/// This protocol owns the shared `body` relationship used by concrete markup namespaces like HTML and SVG.
public protocol MarkupContent<Tag>: _Renderable {
    /// The markup tag this component represents, if any.
    associatedtype Tag: MarkupTagDefinition = Body.Tag

    /// The type of markup content this component represents.
    associatedtype Body: MarkupContent

    /// The markup content of this component.
    @ContentBuilder var body: Body { get }
}

public extension MarkupContent where Body == Never {
    var body: Never {
        #if hasFeature(Embedded)
        fatalError("content was called on an unsupported type")
        #else
        fatalError("content cannot be called on \(Self.self)")
        #endif
    }
}

public extension MarkupContent {
    @inlinable
    static func _render<Renderer: _HTMLRendering>(
        _ html: consuming Self,
        into renderer: inout Renderer,
        with context: consuming _RenderingContext
    ) {
        Body._render(html.body, into: &renderer, with: context)
    }

    @inlinable
    @_unavailableInEmbedded
    static func _render<Renderer: _AsyncHTMLRendering>(
        _ html: consuming Self,
        into renderer: inout Renderer,
        with context: consuming _RenderingContext
    ) async throws {
        try await Body._render(html.body, into: &renderer, with: context)
    }
}

/// A type that represents HTML content that can be rendered.
///
/// You can create reusable HTML components by conforming to this protocol
/// and implementing the ``body`` property.
///
/// ```swift
/// struct FeatureList: HTML {
///   var features: [String]
///
///   var body: some HTML {
///     ul {
///       for feature in features {
///         li { feature }
///       }
///     }
///   }
/// }
/// ```
public protocol HTML<Tag>: MarkupContent where Tag: HTMLTagDefinition, Body: HTML {}

/// A type that represents a markup tag.
public protocol MarkupTagDefinition: Sendable {
    /// The name of the tag as it is rendered in a document.
    static var name: String { get }

    /// Internal property that controls formatted rendering of the element (inline or block).
    ///
    /// A default implementation is provided that returns `false`.
    static var _rendersInline: Bool { get }
}

/// A type that represents an HTML tag.
public protocol HTMLTagDefinition: MarkupTagDefinition {}

extension Never: MarkupTagDefinition {
    public static var name: String { fatalError("MarkupTag.name was called on Never") }
}

extension Never: HTMLTagDefinition {}

public struct _RenderingContext {
    @usableFromInline
    var attributes: _AttributeStorage

    public static var emptyContext: Self { Self(attributes: .none) }
}

// TODO: think about this interface... seems not ideal
public enum _HTMLRenderToken {
    public enum RenderingType {
        case block
        case inline
    }

    case startTag(String, attributes: _MergedAttributes, isUnpaired: Bool, type: RenderingType)
    case endTag(String, type: RenderingType)
    case text(String)
    case raw(String)
    case comment(String)
}

public protocol _HTMLRendering {
    mutating func appendToken(_ token: consuming _HTMLRenderToken)
}

public protocol _AsyncHTMLRendering {
    mutating func appendToken(_ token: consuming _HTMLRenderToken) async throws
}

public extension MarkupTagDefinition {
    @inlinable
    static var _rendersInline: Bool { false }
}
