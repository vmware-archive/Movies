import Foundation
import BrightFutures

enum RepositoryError: ErrorType {
    case FetchFailure
}

protocol MovieRepository {
    func getAll() -> Future<MovieList, RepositoryError>
}

struct NetworkMovieRepository
    <P: DataParser where P.ParsedObject == MovieList>
{
    let http: Http
    let parser: P
}

extension NetworkMovieRepository: MovieRepository {
    func getAll() -> Future<MovieList, RepositoryError> {
        return http.get("\(Environment.apiEndpoint)/movies")
            .mapError { _ in RepositoryError.FetchFailure }
            .flatMap { data in
                return self.parser
                    .parse(data)
                    .mapError { _ in RepositoryError.FetchFailure }
        }
    }
}
