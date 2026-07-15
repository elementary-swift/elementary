import Elementary

extension MainLayout: Sendable where Body: Sendable {}
struct MainLayout<Body: HTML>: HTMLDocument {
    var title: String
    @ContentBuilder var pageContent: Body

    var head: some HTML {
        meta(.name(.viewport), .content("width=device-width, initial-scale=1.0"))
        HTMLComment("Do not use this in production, use the tailwind CLI to generate a production build from your swift files.")
        script(.src("https://cdn.tailwindcss.com")) {}
    }

    var body: some HTML {
        div(.class("flex flex-col min-h-screen items-center font-mono bg-zinc-300")) {
            div(.class("bg-zinc-50 m-12 p-12 rounded-lg shadow-md gap-4")) {
                h1(.class("text-3xl pb-6 mx-auto")) { title }
                main {
                    pageContent
                }
            }
            footer(.class("mt-auto pb-8")) {
                a(.href("https://elementary.codes")) {
                    ElementaryLogo()
                }
            }
        }
    }
}

struct WelcomePage: HTML {
    var body: some HTML {
        div(.class("flex flex-col gap-4")) {
            p {
                "This is a simple example of using "
                i(.class("text-red-800")) { "Elementary" }
                " with Hummingbird."
            }
            form(.action("/greet"), .class("flex flex-col gap-2")) {
                label(.for("name")) { "Enter your name:" }
                input(.type(.text), .name("name"), .autofocus)
                    .roundedTextbox()
                label(.for("count"), .class("mt-2")) { "How many greetings would you like:" }
                input(.type(.number), .name("count"), .value("1"))
                    .roundedTextbox()
                    .attributes(.class("w-20"))
                input(.type(.submit), .class("mt-4"), .value("Let's go!"))
                    .primaryButton()
            }
        }
    }
}

struct GreetingPage: HTML {
    // example of a task-local based environment value
    @Environment(requiring: EnvironmentValues.$name) var name
    var greetingCount: Int

    var body: some HTML {
        if greetingCount < 1 {
            p(.class("text-red-500")) {
                "No greetings to show."
            }
        } else {
            ul {
                ForEach(0..<greetingCount) { i in
                    li {
                        "Hello there, \(name)!"
                        // demo of conditional styling (should be done with CSS in real life)
                    }.attributes(.class("text-orange-700"), when: i % 2 == 0)
                }
            }
        }
    }
}

struct ElementaryLogo: HTML {
    var body: some HTML {
        SVG.svg(.height(60), .viewBox(0, 0, 512, 512)) {
            SVG.linearGradient(.id("bg"), .x1(255.79), .x2(255.79), .y1(512.03), .y2(0.03), .gradientUnits(.userSpaceOnUse)) {
                SVG.stop(.offset(0), .stopColor("#ff5e00"))
                SVG.stop(.offset(1), .stopColor("#ff8e00"))
            }
            SVG.path(
                .fill("url(#bg)"),
                .fillRule(.evenodd),
                .d(
                    "M258.51 511.96c-8.05.24-15.27-.16-20.3-1.12-4.3-.82-18.95-4.55-32.55-8.3-13.6-3.73-37.51-10.32-53.12-14.62-15.6-4.31-34-9.5-40.87-11.54s-15.4-5.03-18.93-6.66a52 52 0 0 1-11.27-7.43c-2.66-2.45-5.97-6.4-7.36-8.77a71 71 0 0 1-4.64-10.44c-1.35-3.94-2.84-13.56-4.17-27-1.13-11.47-4.64-49.8-7.79-85.16A287810 287810 0 0 1 37.73 108.3l-4.19-47.12c-.82-9.31-1.5-20.3-1.52-24.43A74 74 0 0 1 33.13 24c.62-2.9 2.61-7.48 4.43-10.18a32 32 0 0 1 8.1-7.85c3.03-1.87 7.83-3.5 13.01-4.42C65.21.37 82.2.06 142.02.04 217.14 0 217.14 0 217.87 3.9c.4 2.15 2.17 6.64 3.94 9.97 1.78 3.34 5.27 7.86 7.76 10.06s6.55 4.94 9.01 6.1a54 54 0 0 0 10.92 3.27c4.54.82 8.15.85 12.2.1a56 56 0 0 0 10.37-3.1c2.53-1.12 7-4.28 9.95-7.03s6.42-7.13 7.73-9.73a58 58 0 0 0 3.6-9.18c1.2-4.45 1.2-4.45 80.03-4.13 77.48.3 78.95.35 85.38 2.54 3.6 1.23 8.06 3.4 9.92 4.82 1.86 1.41 4.65 4.9 6.2 7.74s3.35 8.4 4.02 12.36c.98 5.8.9 10.91-.46 26.46l-4.85 54.94-8.9 100.24c-3.15 35.5-8.05 90.46-10.89 122.1s-6.12 67.6-7.3 79.9c-1.18 12.29-2.87 25.14-3.76 28.56a68 68 0 0 1-4.2 11.33 44 44 0 0 1-6.95 9.45 53 53 0 0 1-10.61 7.62c-3.44 1.8-10.94 4.73-16.66 6.5-5.73 1.78-29.87 8.64-53.64 15.25a6013 6013 0 0 1-61.44 16.78c-15.71 4.1-19.96 4.82-30.73 5.14"
                )
            )
            SVG.path(
                .fill("#f05139"),
                .fillOpacity(0.25),
                .fillRule(.evenodd),
                .stroke("#ffd1b3"),
                .strokeLinecap(.round),
                .strokeLinejoin(.round),
                .strokeWidth(3),
                .d(
                    "M277.26 468.27c-6.03.43-8.03.14-11.54-1.65a16.6 16.6 0 0 1-6.55-6.28c-1.45-2.58-2.67-7.3-3.3-12.73-.59-5.16-.98-79.56-.96-184.65.01-103.57.42-179.1 1-183.53.54-4.14 1.93-9.39 3.08-11.66a23 23 0 0 1 5.52-6.73c1.88-1.43 5.7-3.21 8.5-3.96 3.96-1.06 20.62-1.36 74.45-1.36 54.02 0 70.34.3 73.84 1.35 2.46.75 6.3 3 8.53 5.02s4.59 5.3 5.25 7.3 1.17 7.94 1.14 13.2c-.03 5.27-4.3 55.15-9.48 110.86s-11.5 123.89-14.05 151.53a4571 4571 0 0 1-5.75 59.62c-.62 5.15-1.86 11.93-2.75 15.07-.9 3.13-2.87 7.42-4.4 9.54a35 35 0 0 1-7.45 7.02c-2.58 1.75-9.14 4.57-14.58 6.28s-22.55 6.49-38.01 10.61c-15.47 4.13-34.22 9.1-41.66 11.07-7.45 1.95-16.82 3.79-20.83 4.08"
                )
            )
            SVG.path(
                .fill("#fff"),
                .fillRule(.evenodd),
                .d(
                    "M360.05 265.57H191.34l6.25 82.27 56.24 13.54 118.72-19.79-5.2 52.07-112.92 24.9-113.08-23.85-22.91-246.83S95 117.3 83.03 103.1c-17.6-20.86-44.78-68.73-44.78-68.73S73 72.07 85.1 82.27c6.05 5.1 36.45 29.16 36.45 29.16s-15.55-18.27-23.95-29.16c-7.53-9.76-34.37-47.9-34.37-47.9s38.98 35.93 56.24 48.94c9.13 6.9 25 17.7 25 17.7l31.04.15 218.9.9-5.2 52.07-208.3-1.04 6.25 66.65 178.1-2.08z"
                )
            )
        }
    }
}

// example of using modifier-like methods to apply styling
extension input {
    // making the return type specify the input tag allows to chain attributes for it
    func roundedTextbox() -> some HTML<HTMLTag.input> {
        attributes(.class("rounded-lg p-2 border border-gray-300"))
    }

    func primaryButton() -> some HTML<HTMLTag.input> {
        attributes(
            .class("rounded-lg p-2 bg-orange-500 text-white font-semibold shadow-sm"),
            .class("hover:bg-orange-600 hover:shadow-xl")
        )
    }
}

enum EnvironmentValues {
    @TaskLocal static var name: String?
}
