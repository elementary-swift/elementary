import Elementary
import Testing

struct TupleRenderingTests {
    @Test func testRendersTuple2() async throws {
        try await HTMLAssertEqual(
            Group {
                p { "1" }
                p { "2" }
            },
            "<p>1</p><p>2</p>"
        )
    }

    @Test func testRendersTuple3() async throws {
        try await HTMLAssertEqual(
            Group {
                p { "1" }
                p { "2" }
                p { "3" }
            },
            "<p>1</p><p>2</p><p>3</p>"
        )
    }

    @Test func testRendersTuple4() async throws {
        try await HTMLAssertEqual(
            Group {
                p { "1" }
                p { "2" }
                p { "3" }
                p { "4" }
            },
            "<p>1</p><p>2</p><p>3</p><p>4</p>"
        )
    }

    @Test func testRendersTuple5() async throws {
        try await HTMLAssertEqual(
            Group {
                p { "1" }
                p { "2" }
                p { "3" }
                p { "4" }
                p { "5" }
            },
            "<p>1</p><p>2</p><p>3</p><p>4</p><p>5</p>"
        )
    }

    @Test func testRendersTuple6() async throws {
        try await HTMLAssertEqual(
            Group {
                p { "1" }
                p { "2" }
                p { "3" }
                p { "4" }
                p { "5" }
                p { "6" }
            },
            "<p>1</p><p>2</p><p>3</p><p>4</p><p>5</p><p>6</p>"
        )
    }

    @Test func testRendersTuple7() async throws {
        try await HTMLAssertEqual(
            Group {
                p { "1" }
                p { "2" }
                p { "3" }
                p { "4" }
                p { "5" }
                p { "6" }
                p { "7" }
            },
            "<p>1</p><p>2</p><p>3</p><p>4</p><p>5</p><p>6</p><p>7</p>"
        )
    }

    @Test func testRendersTuple8() async throws {
        try await HTMLAssertEqual(
            Group {
                p { "1" }
                p { "2" }
                p { "3" }
                p { "4" }
                p { "5" }
                p { "6" }
                p { "7" }
                p { "8" }
            },
            "<p>1</p><p>2</p><p>3</p><p>4</p><p>5</p><p>6</p><p>7</p><p>8</p>"
        )
    }

    @Test func testRendersTuple9() async throws {
        try await HTMLAssertEqual(
            Group {
                p { "1" }
                p { "2" }
                p { "3" }
                p { "4" }
                p { "5" }
                p { "6" }
                p { "7" }
                p { "8" }
                p { "9" }
            },
            "<p>1</p><p>2</p><p>3</p><p>4</p><p>5</p><p>6</p><p>7</p><p>8</p><p>9</p>"
        )
    }

    @Test func testRendersTuple10() async throws {
        try await HTMLAssertEqual(
            Group {
                p { "1" }
                p { "2" }
                p { "3" }
                p { "4" }
                p { "5" }
                p { "6" }
                p { "7" }
                p { "8" }
                p { "9" }
                p { "10" }
            },
            "<p>1</p><p>2</p><p>3</p><p>4</p><p>5</p><p>6</p><p>7</p><p>8</p><p>9</p><p>10</p>"
        )
    }

    @Test func testRendersTuple11() async throws {
        try await HTMLAssertEqual(
            Group {
                p { "1" }
                p { "2" }
                p { "3" }
                p { "4" }
                p { "5" }
                p { "6" }
                p { "7" }
                p { "8" }
                p { "9" }
                p { "10" }
                p { "11" }
            },
            "<p>1</p><p>2</p><p>3</p><p>4</p><p>5</p><p>6</p><p>7</p><p>8</p><p>9</p><p>10</p><p>11</p>"
        )
    }

    @Test func testRendersTuple12() async throws {
        try await HTMLAssertEqual(
            Group {
                p { "1" }
                p { "2" }
                p { "3" }
                p { "4" }
                p { "5" }
                p { "6" }
                p { "7" }
                p { "8" }
                p { "9" }
                p { "10" }
                p { "11" }
                p { "12" }
            },
            "<p>1</p><p>2</p><p>3</p><p>4</p><p>5</p><p>6</p><p>7</p><p>8</p><p>9</p><p>10</p><p>11</p><p>12</p>"
        )
    }

    @Test func testRendersTuple13() async throws {
        try await HTMLAssertEqual(
            Group {
                p { "1" }
                p { "2" }
                p { "3" }
                p { "4" }
                p { "5" }
                p { "6" }
                p { "7" }
                p { "8" }
                p { "9" }
                p { "10" }
                p { "11" }
                p { "12" }
                p { "13" }
            },
            "<p>1</p><p>2</p><p>3</p><p>4</p><p>5</p><p>6</p><p>7</p><p>8</p><p>9</p><p>10</p><p>11</p><p>12</p><p>13</p>"
        )
    }

    @Test func testRendersTuple14() async throws {
        try await HTMLAssertEqual(
            Group {
                p { "1" }
                p { "2" }
                p { "3" }
                p { "4" }
                p { "5" }
                p { "6" }
                p { "7" }
                p { "8" }
                p { "9" }
                p { "10" }
                p { "11" }
                p { "12" }
                p { "13" }
                p { "14" }
            },
            "<p>1</p><p>2</p><p>3</p><p>4</p><p>5</p><p>6</p><p>7</p><p>8</p><p>9</p><p>10</p><p>11</p><p>12</p><p>13</p><p>14</p>"
        )
    }

    @Test func testRendersTuple15() async throws {
        try await HTMLAssertEqual(
            Group {
                p { "1" }
                p { "2" }
                p { "3" }
                p { "4" }
                p { "5" }
                p { "6" }
                p { "7" }
                p { "8" }
                p { "9" }
                p { "10" }
                p { "11" }
                p { "12" }
                p { "13" }
                p { "14" }
                p { "15" }
            },
            "<p>1</p><p>2</p><p>3</p><p>4</p><p>5</p><p>6</p><p>7</p><p>8</p><p>9</p><p>10</p><p>11</p><p>12</p><p>13</p><p>14</p><p>15</p>"
        )
    }
}
