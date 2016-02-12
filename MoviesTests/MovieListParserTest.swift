import XCTest

@testable import Movies

class MovieListParserTest: XCTestCase {
    var parser = MovieListParser()

    func test_parsingListOfMovies() {
        let expectedList = MovieList(
            movies: [Movie(id: 2, title: "Clockwork Orange")]
        )
        let jsonData = "{\"movies\": [{\"id\": 2, \"title\": \"Clockwork Orange\"}]}"
            .dataUsingEncoding(NSUTF8StringEncoding)!


        let parseResult: MovieList? = parser.parse(jsonData)

        XCTAssertEqual(expectedList, parseResult)
    }

    func test_parse_returnsFailedOnMalformedJson() {
        let badJson = "{\"onions\": []}".dataUsingEncoding(NSUTF8StringEncoding)!

        let parseResult: MovieList? = parser.parse(badJson)

        XCTAssertNil(parseResult)
    }

    func test_parse_skipsSingleMalformedRecords() {
        let badJson = "{\"movies\": [{\"id\": 1}, {\"id\": 2, \"title\": \"Barry Lyndon\"}]}"
            .dataUsingEncoding(NSUTF8StringEncoding)!

        let parseResult: MovieList? = parser.parse(badJson)
        let expectedResult = MovieList(
            movies: [Movie(id: 2, title: "Barry Lyndon")]
        )

        XCTAssertEqual(expectedResult, parseResult)
    }
}
