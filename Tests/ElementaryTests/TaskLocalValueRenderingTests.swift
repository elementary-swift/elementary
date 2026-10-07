import Elementary
import Testing

struct TaskLocalValueRenderingTests {
    @Test func testSetsTaskLocalValue() async throws {
        try await HTMLAssertEqual(
            div {
                MyNumber()
                MyNumber()
                    .taskLocalValue(Values.$number, 1)
                MyNumber()
            },
            "<div>010</div>"
        )
    }

    @Test func testNestedOverridesRestoreValues() async throws {
        try await HTMLAssertEqual(
            div {
                MyNumber()
                div {
                    MyNumber()
                    MyNumber().taskLocalValue(Values.$number, 2)
                    MyNumber()
                }.taskLocalValue(Values.$number, 1)
                MyNumber()
            },
            "<div>0<div>121</div>0</div>"
        )
        #expect(Values.number == 0)
    }

    @Test func testOptionalReads() async throws {
        try await HTMLAssertEqual(
            div {
                OptionalNumber()
                OptionalNumber().taskLocalValue(Values.$optionalNumber, 7)
                OptionalNumber()
            },
            "<div>nil7nil</div>"
        )
    }

    @Test func testGetsOptionalTaskLocalValue() async throws {
        try await HTMLAssertEqualAsyncOnly(
            div {
                MyDatabaseValue()
                    .taskLocalValue(Values.$database, Database())
            },
            "<div><p>Hello</p></div>"
        )
    }
}

struct MyNumber: HTML {
    @TaskLocalValue(Values.$number) var number

    var body: some HTML {
        "\(number)"
    }
}

struct MyDatabaseValue: HTML {
    @TaskLocalValue(requiring: Values.$database) var database
    var body: some HTML {
        p {
            await valueAfterSuspension()
        }
    }

    private func valueAfterSuspension() async -> String {
        await Task.yield()
        return await database.value
    }
}

enum Values {
    @TaskLocal static var optionalNumber: Int?
    @TaskLocal static var number = 0
    @TaskLocal static var database: Database?
}

actor Database {
    var value: String = "Hello"
}

private struct OptionalNumber: HTML {
    @TaskLocalValue(Values.$optionalNumber) var number

    var body: some HTML {
        number.map { String($0) } ?? "nil"
    }
}
