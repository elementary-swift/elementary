import Elementary

public protocol SVGTagDefinition: MarkupTagDefinition {}

public protocol SVGContent<Tag>: MarkupContent where Tag: SVGTagDefinition, Body: SVGContent {}

extension Never: SVGTagDefinition {}

public typealias SVGAttribute<Tag: SVGTagDefinition> = MarkupAttribute<Tag>
