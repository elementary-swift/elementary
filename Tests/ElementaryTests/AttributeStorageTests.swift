import Testing

@testable import Elementary

struct AttributeStorageTests {
    @Test func testArrayInitializerWithEmptyArrayCreatesDynamicNone() {
        let emptyAttributes: [HTMLAttribute<HTMLTag.p>] = []
        let storage = _AttributeStorage(emptyAttributes)

        #expect(storage == .none(isStaticallyKnownEmpty: false))
        #expect(storage.isEmpty)
        #expect(!storage.isStaticallyKnownEmpty)
    }

    @Test func testArrayInitializerWithSingleAttributeCreatesSingleStorage() {
        let attributes: [HTMLAttribute<HTMLTag.p>] = [
            .init(name: "id", value: "foo"),
        ]
        let storage = _AttributeStorage(attributes)

        #expect(storage == .single(.init(name: "id", value: "foo", mergeMode: .replaceValue)))
        #expect(!storage.isEmpty)
        #expect(!storage.isStaticallyKnownEmpty)
    }

    @Test func testStaticEmptyStatusForNone() {
        let staticEmpty = _AttributeStorage.none(isStaticallyKnownEmpty: true)
        let dynamicEmpty = _AttributeStorage.none(isStaticallyKnownEmpty: false)

        #expect(staticEmpty.isEmpty)
        #expect(dynamicEmpty.isEmpty)
        #expect(staticEmpty.isStaticallyKnownEmpty)
        #expect(!dynamicEmpty.isStaticallyKnownEmpty)
    }

    @Test func testAppendPropagatesStaticEmptyStatusForNone() {
        var allStatic = _AttributeStorage.none(isStaticallyKnownEmpty: true)
        allStatic.append(.none(isStaticallyKnownEmpty: true))
        #expect(allStatic == .none(isStaticallyKnownEmpty: true))

        var mixedStaticAndDynamic = _AttributeStorage.none(isStaticallyKnownEmpty: true)
        mixedStaticAndDynamic.append(.none(isStaticallyKnownEmpty: false))
        #expect(mixedStaticAndDynamic == .none(isStaticallyKnownEmpty: false))

        var allDynamic = _AttributeStorage.none(isStaticallyKnownEmpty: false)
        allDynamic.append(.none(isStaticallyKnownEmpty: false))
        #expect(allDynamic == .none(isStaticallyKnownEmpty: false))
    }

    @Test func testAppendWithNonEmptyRemainsNonEmpty() {
        let idAttribute = _StoredAttribute(name: "id", value: "foo", mergeMode: .replaceValue)
        var storage = _AttributeStorage.none(isStaticallyKnownEmpty: true)
        storage.append(.single(idAttribute))

        #expect(!storage.isEmpty)
        #expect(!storage.isStaticallyKnownEmpty)
        #expect(storage == .single(idAttribute))

        var nonEmpty = _AttributeStorage.single(idAttribute)
        nonEmpty.append(.none(isStaticallyKnownEmpty: true))
        #expect(nonEmpty == .single(idAttribute))
    }
}
