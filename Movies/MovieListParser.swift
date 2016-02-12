import Foundation
import Result

struct MovieListParser {
    func parse(data: NSData) -> Result<MovieList, ParseError> {
        guard
            let json = try? NSJSONSerialization.JSONObjectWithData(
                data,
                options: []
            ),
            let moviesObj = json as? [String: AnyObject],
            let movies = moviesObj["movies"] as? [AnyObject] else
        {
            return Result.Failure(ParseError.MissingKey)
        }

        let movieCollection: [Movie] = movies
            .map { JsonMovieParser().parse($0) }
            .flatMap { $0 }

        return Result.Success(
            MovieList(movies: movieCollection)
        )
    }
}

private struct JsonMovieParser {
    func parse(json: AnyObject) -> Movie? {
        guard
            let movieObject = json as? [String: AnyObject],
            let movieId = movieObject["id"] as? Int,
            let movieTitle = movieObject["title"] as? String else
        {
            return nil
        }

        return Movie(id: movieId, title: movieTitle)
    }
}
