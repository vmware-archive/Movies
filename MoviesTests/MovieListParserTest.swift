import XCTest

import Result

@testable import Movies

class MovieListParserTest: XCTestCase {
    func test_parsingListOfMovies() {
        let expectedList = MovieList(
            movies: [Movie(id: 2, title: "Clockwork Orange")]
        )
        let parser = MovieListParser()
        let jsonData = "{\"movies\": [{\"id\": 2, \"title\": \"Clockwork Orange\"}]}"
            .dataUsingEncoding(NSUTF8StringEncoding)!


        let parseResult: Result<MovieList, ParseError> = parser.parse(jsonData)


        XCTAssertEqual(expectedList, parseResult.value)
    }

    func test_parse_returnsFailedOnMalformedJson() {
        let parser = MovieListParser()
        let badJson = "{\"onions\": []}".dataUsingEncoding(NSUTF8StringEncoding)!

        let parseResult: Result<MovieList, ParseError> = parser.parse(badJson)

        XCTAssertEqual(ParseError.MissingKey, parseResult.error)
    }

    func test_parse_skipsSingleMalformedRecords() {
        let parser = MovieListParser()
        let badJson = "{\"movies\": [{\"id\": 1}, {\"id\": 2, \"title\": \"Barry Lyndon\"}]}"
            .dataUsingEncoding(NSUTF8StringEncoding)!

        let parseResult: Result<MovieList, ParseError> = parser.parse(badJson)
        let expectedResult = MovieList(
            movies: [Movie(id: 2, title: "Barry Lyndon")]
        )

        XCTAssertEqual(expectedResult, parseResult.value)
    }
}
