import Elementary
import Testing

struct SendOnceHTMLValueTests {
    @Test func testHoldsSendableValue() {
        let html = div { "Hello, World!" }
        let box = _SendableAnyHTMLBox(html)
        #expect(box.tryTake() != nil)
        #expect(box.tryTake() != nil)
    }

    @available(macOS 15.0, *)
    @Test func testHoldsNonSendable() {
        let html = MyComponent()
        let box = _SendableAnyHTMLBox(html)
        #expect(box.tryTake() != nil)
        #expect(box.tryTake() == nil)
    }
}

class NonSendable {
    var x: Int = 0
}

struct MyComponent: HTML {
    let ns = NonSendable()
    var body: some HTML {
        div { "\(ns.x)" }
    }
}
