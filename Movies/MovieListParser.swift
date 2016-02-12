import Foundation

struct MovieListParser {
    func parse(data: NSData) -> MovieList? {
        guard
            let json = try? NSJSONSerialization.JSONObjectWithData(
                data,
                options: []
            ),
            let moviesObj = json as? [String: AnyObject],
            let movies = moviesObj["movies"] as? [AnyObject] else
        {
            return nil
        }

        let movieCollection: [Movie] = movies
            .map { SingleJsonMovieParser().parse($0) }
            .flatMap { $0 }

        return MovieList(movies: movieCollection)
    }
}

private struct SingleJsonMovieParser {
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
