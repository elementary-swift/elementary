import Elementary
import Testing

func HTMLAssertEqual(_ html: some HTML, _ expected: String, sourceLocation: SourceLocation = #_sourceLocation) async throws {
    #expect(expected == html.render(), sourceLocation: sourceLocation)

    try await HTMLAssertEqualAsyncOnly(html, expected, sourceLocation: sourceLocation)
}

func HTMLAssertEqualAsyncOnly(_ html: some HTML, _ expected: String, sourceLocation: SourceLocation = #_sourceLocation) async throws {
    let asyncText = try await html.renderAsync()
    #expect(expected == asyncText, sourceLocation: sourceLocation)
}

func HTMLFormattedAssertEqual(_ html: some HTML, _ expected: String, sourceLocation: SourceLocation = #_sourceLocation) {
    #expect(expected == html.renderFormatted(), sourceLocation: sourceLocation)
}

final class TestBufferWriter: HTMLStreamWriter {
    var result: [UInt8] = []
    var writeCount: Int = 0

    func write(_ bytes: ArraySlice<UInt8>) async throws {
        writeCount += 1
        result.append(contentsOf: bytes)
    }
}
