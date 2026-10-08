import Elementary
import Testing

// Model the existing attribute-specific ElementaryUI bridge. Conformance
// extensions on the compatibility alias need explicit specialization constraints.
private protocol LegacyFixtureMountable {
    associatedtype LegacyNode
    static func makeLegacyNode(_ content: consuming Self) -> LegacyNode
    static func patchLegacyNode(_ content: consuming Self, node: inout LegacyNode)
}

extension _AttributedContent: LegacyFixtureMountable
where Content: MarkupContent & LegacyFixtureMountable, Modifier == _AttributesModifier<Content> {
    fileprivate typealias LegacyNode = (attributes: _AttributeStorage, child: Content.LegacyNode)

    fileprivate static func makeLegacyNode(_ content: consuming Self) -> LegacyNode {
        (content._attributes, Content.makeLegacyNode(content.content))
    }

    fileprivate static func patchLegacyNode(_ content: consuming Self, node: inout LegacyNode) {
        node.attributes = content._attributes
        Content.patchLegacyNode(content.content, node: &node.child)
    }
}

// A separate protocol models the future generic mounting bridge, including
// modifiers that do not participate in server-side markup rendering.
private protocol GenericFixtureMountable {
    associatedtype GenericNode
    static func makeGenericNode(_ content: consuming Self) -> GenericNode
}

private protocol FixtureMountingModifier {
    associatedtype State
    var state: State { get }
}

extension ModifiedContent: GenericFixtureMountable
where Content: GenericFixtureMountable, Modifier: FixtureMountingModifier {
    fileprivate typealias GenericNode = (state: Modifier.State, child: Content.GenericNode)

    fileprivate static func makeGenericNode(_ content: consuming Self) -> GenericNode {
        (content.modifier.state, Content.makeGenericNode(content.content))
    }
}

// This module imports Elementary without @testable. Construction must also be
// usable from code serialized into another module's inlinable function body.
@inlinable
func makeFixtureModified<Content, Modifier>(
    _ content: Content,
    _ modifier: Modifier
) -> ModifiedContent<Content, Modifier> {
    ModifiedContent(content: content, modifier: modifier)
}

private struct FixtureContent: HTML, LegacyFixtureMountable, GenericFixtureMountable {
    var value: String
    var body: some HTML { p { value } }

    static func makeLegacyNode(_ content: consuming Self) -> String { content.value }
    static func patchLegacyNode(_ content: consuming Self, node: inout String) { node = content.value }
    static func makeGenericNode(_ content: consuming Self) -> String { content.value }
}

private struct FixtureModifier: FixtureMountingModifier {
    var state: Int
}

struct ModifiedContentCompatibilityTests {
    @Test func downstreamAttributeAndGenericMountingBridges() {
        var attributed = _AttributedContent(content: FixtureContent(value: "first"))
        var node = type(of: attributed).makeLegacyNode(attributed)
        #expect(node.child == "first")
        attributed.content.value = "second"
        attributed._attributes = .init(.id("updated") as HTMLAttribute<HTMLTag.p>)
        type(of: attributed).patchLegacyNode(attributed, node: &node)
        #expect(node.child == "second")
        #expect(node.attributes == attributed._attributes)

        let generic = makeFixtureModified(FixtureContent(value: "generic"), FixtureModifier(state: 7))
        let genericNode = type(of: generic).makeGenericNode(generic)
        #expect(genericNode.state == 7)
        #expect(genericNode.child == "generic")
    }
}
