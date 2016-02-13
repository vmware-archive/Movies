import XCTest
import Foundation
import BrightFutures

@testable import Movies

class MovieViewControllerTest: XCTestCase {
    let fakeMovieRepository = FakeMovieRepository()
    let promise = Promise<MovieList, RepositoryError>()

    var controller: MovieViewController!

    override func setUp() {
        fakeMovieRepository.getAll_returnValue = promise.future

        controller = MovieViewController(
            movieRepository: fakeMovieRepository
        )
    }

    // MARK: - loadView

    func test_loadView_loadsMovieData() {
        let _ = controller.view

        XCTAssertTrue(fakeMovieRepository.getAll_wasCalled)

        let moviesFromAPI = MovieList(movies: [Movie(id: 1, title: "2001")])
        promise.success(moviesFromAPI)

        NSRunLoop.advance(by: NSTimeInterval(0.001))

        XCTAssertEqual(moviesFromAPI, controller.allMovies)
    }

    // MARK: - tableView

    func test_tableView_returnsNumberOfRowsBasedOnMovieCount() {
        controller.allMovies = MovieList(
            movies: [Movie(id: 1, title: "The Shining")]
        )
        var numberOfRows = controller.tableView(
            UITableView(),
            numberOfRowsInSection: 0
        )

        XCTAssertEqual(1, numberOfRows)

        controller.allMovies = MovieList(movies: [])
        numberOfRows = controller.tableView(
            UITableView(),
            numberOfRowsInSection: 0
        )

        XCTAssertEqual(0, numberOfRows)
    }

    func test_tableView_returnsCellsWithMovieTitle() {
        controller.allMovies = MovieList(
            movies: [Movie(id: 1, title: "The Shining")]
        )

        let cell: UITableViewCell = controller.tableView(
            UITableView(),
            cellForRowAtIndexPath: NSIndexPath(forRow: 0, inSection: 0)
        )

        XCTAssertEqual("The Shining", cell.textLabel?.text)
    }
}
