import XCTest
import Foundation

import Result

@testable import Movies

class MovieParserTest: XCTestCase {
    func test_parse_createsMovieObjects() {
        let parser = MovieParser()
        let jsonData = "{\"id\": 1, \"title\": \"The Shining\"}"
            .dataUsingEncoding(NSUTF8StringEncoding)!
        let actualMovie: Result<Movie, ParseError> = parser.parse(jsonData)

        XCTAssertEqual(Movie(id: 1, title: "The Shining"), actualMovie.value)
    }

    func test_parse_returnsErrorResultWhenFieldsAreMissing() {
        let parser = MovieParser()
        let noTitle = "{\"id\": 1}".dataUsingEncoding(NSUTF8StringEncoding)!
        let result: Result<Movie, ParseError> = parser.parse(noTitle)

        XCTAssertEqual(ParseError.MissingKey, result.error)
    }
}
