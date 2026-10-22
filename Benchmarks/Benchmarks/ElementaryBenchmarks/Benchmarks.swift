@preconcurrency import Benchmark
import Elementary

let benchmarks = { @Sendable in
    Benchmark.defaultConfiguration = .init(
        metrics: [.wallClock, .mallocCountTotal, .instructions, .throughput],
        scalingFactor: .kilo,
        maxDuration: .seconds(5)
    )

    Benchmark("initialize nested html tags") { benchmark in
        for _ in benchmark.scaledIterations {
            blackHole(makeNestedTagsElement())
        }
    }

    Benchmark("initialize single attribute elements") { benchmark in
        for _ in benchmark.scaledIterations {
            blackHole(makeSingleAttributeElements())
        }
    }

    Benchmark("initialize multi attribute elements") { benchmark in
        for _ in benchmark.scaledIterations {
            blackHole(makeMultiAttributeElements())
        }
    }

    Benchmark("render nested html tags") { benchmark in
        let element = makeNestedTagsElement()
        benchmark.startMeasurement()
        for _ in benchmark.scaledIterations {
            try blackHole(await element.renderAsync())
        }
    }

    Benchmark("render nested custom elements") { benchmark in
        let element = makeNestedCustomElement()
        benchmark.startMeasurement()
        for _ in benchmark.scaledIterations {
            try blackHole(await element.renderAsync())
        }
    }

    Benchmark("render single attribute elements") { benchmark in
        let element = makeSingleAttributeElements()
        benchmark.startMeasurement()
        for _ in benchmark.scaledIterations {
            try blackHole(await element.renderAsync())
        }
    }

    Benchmark("render multi attribute elements") { benchmark in
        let element = makeMultiAttributeElements()
        benchmark.startMeasurement()
        for _ in benchmark.scaledIterations {
            try blackHole(await element.renderAsync())
        }
    }

    Benchmark("render nested html tags (sync)") { benchmark in
        let element = makeNestedTagsElement()
        benchmark.startMeasurement()
        for _ in benchmark.scaledIterations {
            blackHole(element.render())
        }
    }

    Benchmark("render merged attributes") { benchmark in
        benchmark.startMeasurement()
        for _ in benchmark.scaledIterations {
            try blackHole(
                await p {
                    img(.class("1"), .style("1"), .id("old"))
                        .attributes(.class("2"), .style("2"))
                        .attributes(.id("new"))
                }.renderAsync()
            )
        }
    }

    Benchmark("render many attributes (sync)") { benchmark in
        let element = makeManyAttributesElements()
        benchmark.startMeasurement()
        for _ in benchmark.scaledIterations {
            blackHole(element.render())
        }
    }

    Benchmark("render merged attributes (sync)") { benchmark in
        let element = makeMergedAttributesElements()
        benchmark.startMeasurement()
        for _ in benchmark.scaledIterations {
            blackHole(element.render())
        }
    }

    Benchmark("render class and style lists (sync)") { benchmark in
        let element = makeClassAndStyleElements()
        benchmark.startMeasurement()
        for _ in benchmark.scaledIterations {
            blackHole(element.render())
        }
    }

    Benchmark("render 5 attributes in one list (sync)") { benchmark in
        let element = makeAttributeListElements(count: 5)
        benchmark.startMeasurement()
        for _ in benchmark.scaledIterations {
            blackHole(element.render())
        }
    }

    Benchmark("render 10 attributes in one list (sync)") { benchmark in
        let element = makeAttributeListElements(count: 10)
        benchmark.startMeasurement()
        for _ in benchmark.scaledIterations {
            blackHole(element.render())
        }
    }

    Benchmark("render 15 attributes in one list (sync)") { benchmark in
        let element = makeAttributeListElements(count: 15)
        benchmark.startMeasurement()
        for _ in benchmark.scaledIterations {
            blackHole(element.render())
        }
    }

    Benchmark("compare attribute storage") { benchmark in
        let a = makeAttributeStorage(seed: "1")
        let b = makeAttributeStorage(seed: "1")
        let c = makeAttributeStorage(seed: "2")
        benchmark.startMeasurement()
        for _ in benchmark.scaledIterations {
            blackHole(a == b)
            blackHole(a == c)
        }
    }

    Benchmark("render tuples") { benchmark in
        for _ in benchmark.scaledIterations {
            try blackHole(
                await div {
                    img()
                    img()
                    img()
                    img()
                    div {
                        img()
                        img()
                        img()
                        img()
                        div {
                            img()
                            img()
                        }
                    }
                }.renderAsync()
            )
        }
    }

    Benchmark("render array") { benchmark in
        for _ in benchmark.scaledIterations {
            try blackHole(
                await div {
                    for i in 0..<1000 {
                        img(.id("\(i)"))
                    }
                }.renderAsync()
            )
        }
    }

    Benchmark("render sequence") { benchmark in
        for _ in benchmark.scaledIterations {
            try blackHole(
                await div {
                    ForEach(0..<1000) { i in
                        img(.id("\(i)"))
                    }
                }.renderAsync()
            )
        }
    }

    Benchmark("render text") { benchmark in
        for _ in benchmark.scaledIterations {
            try blackHole(
                await div {
                    "Hello, World!"
                    "This is a paragraph."
                    "Some interpolation \("maybe")"
                    i { "Italic" }
                    b { "Bold" }
                }.renderAsync()
            )
        }
    }

    Benchmark("render full document") { benchmark in
        for _ in benchmark.scaledIterations {
            try blackHole(
                await html {
                    head {
                        title { "Hello, World!" }
                        meta(.name("viewport"), .content("width=device-width, initial-scale=1"))
                        link(.rel("stylesheet"), .href("styles.css"))
                    }
                    body {
                        h1(.class("hello")) { "Hello, World!" }
                        p { "This is a paragraph." }
                        a(.href("https://swift.org")) {
                            "Swift"
                        }
                        ul(.class("fancy-list")) {
                            ForEach(0..<1000) { i in
                                MyCustomElement {
                                    MyListItem(number: i)
                                }
                                HTMLComment("This is a comment")
                            }
                        }
                    }
                }.renderAsync()
            )
        }
    }

    Benchmark("render full document (sync)") { benchmark in
        for _ in benchmark.scaledIterations {
            blackHole(
                html {
                    head {
                        title { "Hello, World!" }
                        meta(.name("viewport"), .content("width=device-width, initial-scale=1"))
                        link(.rel("stylesheet"), .href("styles.css"))
                    }
                    body {
                        h1(.class("hello")) { "Hello, World!" }
                        p { "This is a paragraph." }
                        a(.href("https://swift.org")) {
                            "Swift"
                        }
                        ul(.class("fancy-list")) {
                            ForEach(0..<1000) { i in
                                MyCustomElement {
                                    MyListItem(number: i)
                                }
                                HTMLComment("This is a comment")
                            }
                        }
                    }
                }.render()
            )
        }
    }
}

func makeNestedTagsElement() -> some HTML {
    body {
        main {
            section {
                div {
                    p {
                        span {
                            i {}
                        }
                    }
                }
            }
        }
    }
}

func makeNestedCustomElement() -> some HTML {
    MyCustomElement {
        MyCustomElement {
            MyCustomElement {
                MyCustomElement {}
            }
        }
    }
}

func makeMultiAttributeElements() -> some HTML {
    div(.id("1"), .class("2")) {
        div(.id("3"), .class("4")) {
            div(.id("5"), .class("6")) {
                div(.id("7"), .class("8")) {}
            }
        }
    }
}

func makeManyAttributesElements() -> some HTML {
    div {
        ForEach(0..<100) { i in
            input(.type(.text), .name("field"), .id("f\(i)"), .class("input"), .placeholder("Type here"), .required)
            a(.href("/items"), .class("link"), .target(.blank), .rel("noopener")) { "link" }
        }
    }
}

func makeAttributeListElements(count: Int) -> some HTML {
    // realistic names, including several that share a length (eg: type/name, class/title/value)
    let attributes: [HTMLAttribute<HTMLTag.input>] = Array(
        [
            .type(.text), .name("email"), .id("email-input"), .class("form-control"), .placeholder("you@example.com"),
            .value("someone@example.com"), .custom(name: "autocomplete", value: "email"), .maxlength(120), .title("Email address"),
            .required,
            .minlength(3), .pattern("[^@]+@[^@]+"), .custom(name: "aria-label", value: "Email"), .data("testid", value: "email"),
            .readonly,
        ].prefix(count)
    )

    return div {
        for _ in 0..<100 {
            input(attributes: attributes)
        }
    }
}

func makeMergedAttributesElements() -> some HTML {
    div {
        ForEach(0..<100) { i in
            img(.class("1"), .style("1"), .id("old"))
                .attributes(.class("2"), .style("2"))
                .attributes(.id("new\(i)"))
            p(.id("p"), .class("a")) { "text" }
                .attributes(.class("b"), when: i.isMultiple(of: 2))
        }
    }
}

func makeClassAndStyleElements() -> some HTML {
    div {
        ForEach(0..<100) { _ in
            p(.class(["foo", "bar"]), .style(["color": "red", "font-size": "16px"])) {}
                .attributes(.class(["baz", "foo"]), .style(["font-size": "24px"]))
        }
    }
}

func makeAttributeStorage(seed: String) -> _AttributeStorage {
    var storage = _AttributeStorage([
        MarkupAttribute<HTMLTag.div>.id("id-\(seed)"),
        .class("card"),
        .data("index", value: seed),
        .style("color: red"),
    ])
    storage.append(_AttributeStorage(MarkupAttribute<HTMLTag.div>.class("active")))
    return storage
}

func makeSingleAttributeElements() -> some HTML {
    div(.id("1")) {
        div(.id("3")) {
            div(.id("5")) {
                div(.id("7")) {}
            }
        }
    }
}

struct MyCustomElement<H: HTML>: HTML {
    var myContent: H

    init(@ContentBuilder content: () -> H) {
        myContent = content()
    }

    var body: some HTML {
        myContent
    }
}

struct MyListItem: HTML {
    let number: Int

    var body: some HTML {
        let isEven = number.isMultiple(of: 2)

        li(.id("\(number)")) {
            if isEven {
                "Even Item \(number)"
            } else {
                "Item \(number)"
            }
        }.attributes(.class("even"), when: isEven)
    }
}
