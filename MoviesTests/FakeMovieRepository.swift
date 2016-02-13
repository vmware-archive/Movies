import BrightFutures

@testable import Movies

class FakeMovieRepository: MovieRepository {
    var getAll_wasCalled = false
    var getAll_returnValue = Future<MovieList, RepositoryError>()
    func getAll() -> Future<MovieList, RepositoryError> {
        getAll_wasCalled = true

        return getAll_returnValue
    }
}
