import Elementary

public protocol SVGTagDefinition: MarkupTagDefinition {}
public typealias SVGAttribute = MarkupAttribute

public protocol SVGContent<Tag>: MarkupContent where Tag: SVGTagDefinition, Body: SVGContent {}

extension Never: SVGTagDefinition {}
