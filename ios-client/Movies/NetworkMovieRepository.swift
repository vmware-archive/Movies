import Foundation
import BrightFutures

enum RepositoryError: ErrorType {
    case FetchFailure
}

#if PRODUCTION
let API_ENDPOINT = "http://localhost:8080/movies"
#elseif ACCEPTANCE
let API_ENDPOINT = "http://localhost:8080/movies"
#else // DEVELOPMENT
let API_ENDPOINT = "http://localhost:8080/movies"
#endif

protocol MovieRepository {
    func getAll() -> Future<MovieList, RepositoryError>
}

struct NetworkMovieRepository<P: DataParser where P.ParsedObject == MovieList>: MovieRepository {
    let http: Http
    let parser: P

    func getAll() -> Future<MovieList, RepositoryError> {
        return http.get(API_ENDPOINT)
            .mapError { _ in RepositoryError.FetchFailure }
            .flatMap { data in
                return self.parser
                    .parse(data)
                    .mapError { _ in RepositoryError.FetchFailure }
            }
    }
}
