import XCTest
import BrightFutures

@testable import Movies

class NetworkMovieRepositoryTest: XCTestCase {
    let promise = Promise<NSData, HttpError>()
    let fakeHttp = FakeHttp()

    var repository: NetworkMovieRepository<MovieListParser>!

    override func setUp() {
        fakeHttp.get_returnValue = promise.future

        repository = NetworkMovieRepository(
            http: fakeHttp,
            parser: MovieListParser()
        )
    }

    func test_getAll_parsesHttpResponse() {
        let expectation = self.expectationWithDescription("Resolved Promise")
        var actualMovieList: MovieList!


        repository.getAll().onSuccess { movieList in
            actualMovieList = movieList
            expectation.fulfill()
        }


        XCTAssertEqual(fakeHttp.get_args, "http://localhost:8080/movies")

        promise.success(
            ("{\"movies\": [{" +
                "\"id\": 3," +
                "\"title\": \"Lolita\"," +
                "\"director\":\"Stanley Kubrick\"}]}")
                .dataUsingEncoding(NSUTF8StringEncoding)!
        )
        waitForExpectationsWithTimeout(1, handler: nil)

        let expectedMovieList = MovieList(
            movies: [Movie(id: 3, title: "Lolita", director: "Stanley Kubrick")]
        )
        XCTAssertEqual(expectedMovieList, actualMovieList)
    }

    func test_getAll_whenHttpRequestFails() {
        let expectation = self.expectationWithDescription("Resolved Promise")
        var actualError: RepositoryError!


        repository.getAll().onFailure { error in
            actualError = error
            expectation.fulfill()
        }


        promise.failure(HttpError.BadRequest)
        waitForExpectationsWithTimeout(1, handler: nil)

        XCTAssertEqual(RepositoryError.FetchFailure, actualError)
    }

    func test_getAll_whenParseFails() {
        let expectation = self.expectationWithDescription("Resolved Promise")
        var actualError: RepositoryError!


        repository.getAll().onFailure { error in
            actualError = error
            expectation.fulfill()
        }


        promise.success("{\"movies".dataUsingEncoding(NSUTF8StringEncoding)!)
        waitForExpectationsWithTimeout(1, handler: nil)

        XCTAssertEqual(RepositoryError.FetchFailure, actualError)
    }
}
