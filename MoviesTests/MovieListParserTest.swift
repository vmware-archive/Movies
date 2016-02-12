import XCTest

@testable import Movies

class MovieListParserTest: XCTestCase {
    func test_parsingListOfMovies() {
        let expectedList = MovieList(
            movies: [Movie(id: 2, title: "Clockwork Orange")]
        )
        let parser = MovieListParser()
        let jsonData = "{\"movies\": [{\"id\": 2, \"title\": \"Clockwork Orange\"}]}"
            .dataUsingEncoding(NSUTF8StringEncoding)!


        let parseResult: MovieList? = parser.parse(jsonData)

        XCTAssertEqual(expectedList, parseResult)
    }

    func test_parse_returnsFailedOnMalformedJson() {
        let parser = MovieListParser()
        let badJson = "{\"onions\": []}".dataUsingEncoding(NSUTF8StringEncoding)!

        let parseResult: MovieList? = parser.parse(badJson)

        XCTAssertNil(parseResult)
    }

    func test_parse_skipsSingleMalformedRecords() {
        let parser = MovieListParser()
        let badJson = "{\"movies\": [{\"id\": 1}, {\"id\": 2, \"title\": \"Barry Lyndon\"}]}"
            .dataUsingEncoding(NSUTF8StringEncoding)!

        let parseResult: MovieList? = parser.parse(badJson)
        let expectedResult = MovieList(
            movies: [Movie(id: 2, title: "Barry Lyndon")]
        )

        XCTAssertEqual(expectedResult, parseResult)
    }
}
