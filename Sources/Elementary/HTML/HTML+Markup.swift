extension _AttributedElement: HTML where Tag: HTMLTagDefinition, Content: HTML {}

extension MarkupElement: HTML where Tag: HTMLTrait.Paired, Content: HTML {}
