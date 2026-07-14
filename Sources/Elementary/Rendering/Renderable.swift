#if !hasFeature(Embedded)
/// A type that represents markup content that can be rendered.
///
/// This protocol contains the namespace-neutral rendering machinery shared by HTML and SVG.
public protocol _Renderable {
    static func _render<Renderer: _HTMLRendering>(
        _ html: consuming Self,
        into renderer: inout Renderer,
        with context: consuming _RenderingContext
    )

    @_unavailableInEmbedded
    static func _render<Renderer: _AsyncHTMLRendering>(
        _ html: consuming Self,
        into renderer: inout Renderer,
        with context: consuming _RenderingContext
    ) async throws
}

public struct _RenderingContext {
    @usableFromInline
    package var attributes: _AttributeStorage

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
    case selfClosingTag(String, attributes: _MergedAttributes)
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
#else
// empty protocol for embedded
public typealias _Renderable = Any
#endif
