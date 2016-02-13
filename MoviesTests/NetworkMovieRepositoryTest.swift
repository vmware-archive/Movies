import XCTest
import BrightFutures

@testable import Movies

class NetworkMovieRepositoryTest: XCTestCase {
    func test_getAll_parsesHttpResponse() {
        let fakeHttp = FakeHttp()
        let promise = Promise<NSData, HttpError>()
        fakeHttp.get_returnValue = promise.future
        let expectation = self.expectationWithDescription("Resolved Promise")

        let repository = NetworkMovieRepository(
            http: fakeHttp,
            parser: MovieListParser()
        )
        let expectedMovieList = MovieList(
            movies: [Movie(id: 3, title: "Lolita")]
        )
        var actualMovieList: MovieList!


        repository.getAll().onSuccess { movieList in
            actualMovieList = movieList
            expectation.fulfill()
        }


        XCTAssertEqual(fakeHttp.get_args, "http://localhost:8080/movies")

        let jsonData = "{\"movies\": [{\"id\": 3, \"title\": \"Lolita\"}]}"
            .dataUsingEncoding(NSUTF8StringEncoding)!
        promise.success(jsonData)
        waitForExpectationsWithTimeout(1, handler: nil)

        XCTAssertEqual(expectedMovieList, actualMovieList)
    }

    func test_getAll_whenHttpRequestFails() {
        let fakeHttp = FakeHttp()
        let promise = Promise<NSData, HttpError>()
        fakeHttp.get_returnValue = promise.future
        let expectation = self.expectationWithDescription("Resolved Promise")

        let repository = NetworkMovieRepository(
            http: fakeHttp,
            parser: MovieListParser()
        )
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
        let fakeHttp = FakeHttp()
        let promise = Promise<NSData, HttpError>()
        fakeHttp.get_returnValue = promise.future
        let expectation = self.expectationWithDescription("Resolved Promise")

        let repository = NetworkMovieRepository(
            http: fakeHttp,
            parser: MovieListParser()
        )
        var actualError: RepositoryError!


        repository.getAll().onFailure { error in
            actualError = error
            expectation.fulfill()
        }

        let badJson = "{\"movies".dataUsingEncoding(NSUTF8StringEncoding)!
        promise.success(badJson)
        waitForExpectationsWithTimeout(1, handler: nil)

        XCTAssertEqual(RepositoryError.FetchFailure, actualError)
    }
}
