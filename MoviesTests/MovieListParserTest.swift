import XCTest
import Result

@testable import Movies

class MovieListParserTest: XCTestCase {
    var parser = MovieListParser()

    func test_parsingListOfMovies() {
        let expectedList = MovieList(
            movies: [Movie(id: 2, title: "Clockwork Orange")]
        )
        let jsonData = "{\"movies\": [{\"id\": 2, \"title\": \"Clockwork Orange\"}]}"
            .dataUsingEncoding(NSUTF8StringEncoding)!


        let parseResult: Result<MovieList, MovieParseError> = parser.parse(jsonData)

        XCTAssertEqual(expectedList, parseResult.value)
    }

    func test_parse_returnsFailedOnMalformedJson() {
        let badJson = "{\"onions\": []}".dataUsingEncoding(NSUTF8StringEncoding)!

        let parseResult: Result<MovieList, MovieParseError> = parser.parse(badJson)

        XCTAssertNil(parseResult.value)
        XCTAssertEqual(MovieParseError.MalformedData, parseResult.error)
    }

    func test_parse_skipsSingleMalformedRecords() {
        let badJson = "{\"movies\": [{\"id\": 1}, {\"id\": 2, \"title\": \"Barry Lyndon\"}]}"
            .dataUsingEncoding(NSUTF8StringEncoding)!

        let parseResult: Result<MovieList, MovieParseError> = parser.parse(badJson)
        let expectedResult = MovieList(
            movies: [Movie(id: 2, title: "Barry Lyndon")]
        )

        XCTAssertEqual(expectedResult, parseResult.value)
    }
}
