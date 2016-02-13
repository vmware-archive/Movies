import Foundation
import BrightFutures

enum RepositoryError: ErrorType {
    case FetchFailure
}

struct NetworkMovieRepository<P: DataParser where P.ParsedObject == MovieList> {
    let http: Http
    let parser: P

    func getAll() -> Future<MovieList, RepositoryError> {
        return http.get("http://localhost:8080/movies")
            .mapError { _ in RepositoryError.FetchFailure }
            .flatMap { data in
                return self.parser
                    .parse(data)
                    .mapError { _ in RepositoryError.FetchFailure }
            }
    }
}
