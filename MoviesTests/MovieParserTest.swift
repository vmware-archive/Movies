import XCTest
import Foundation

@testable import Movies

class MovieParserTest: XCTestCase {
    func test_parse_createsMovieObjects() {
        let parser = MovieParser()
        let jsonData = "{\"id\": 1, \"title\": \"The Shining\"}"
            .dataUsingEncoding(NSUTF8StringEncoding)!
        let actualMovie: Movie? = parser.parse(jsonData)

        XCTAssertEqual(Movie(id: 1, title: "The Shining"), actualMovie)
    }

    func test_parse_returnsErrorResultWhenFieldsAreMissing() {
        let parser = MovieParser()
        let noTitle = "{\"id\": 1}".dataUsingEncoding(NSUTF8StringEncoding)!
        let result: Movie? = parser.parse(noTitle)

        XCTAssertNil(result)
    }
}
