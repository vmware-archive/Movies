import XCTest
import Foundation
import BrightFutures

@testable import Movies

class MovieViewControllerTest: XCTestCase {
    let fakeMovieRepository = FakeMovieRepository()
    var promise = Promise<MovieList, RepositoryError>()

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

        NSRunLoop.advance(by: 0.01)

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

    func test_tableView_refreshesData() {
        let _ = controller.view
        let initialAPIData = MovieList(movies: [])
        promise.success(initialAPIData)
        NSRunLoop.advance(by: NSTimeInterval(0.001))

        let secondPromise = Promise<MovieList, RepositoryError>()
        fakeMovieRepository.getAll_returnValue = secondPromise.future

        XCTAssertFalse(controller.refreshControl.refreshing)


        controller.refreshControl.sendActionsForControlEvents(
            UIControlEvents.ValueChanged
        )



        XCTAssertTrue(controller.refreshControl.refreshing)

        secondPromise.success(MovieList(movies: [Movie(id: 1, title: "2001")]))
        NSRunLoop.advance(by: NSTimeInterval(0.001))

        XCTAssertFalse(controller.refreshControl.refreshing)
    }
}
