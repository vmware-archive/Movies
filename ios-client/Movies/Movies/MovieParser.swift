import Foundation
import Result

struct MovieParser: DataParser {
    typealias ParsedObject = Movie

    func parse(data: NSData) -> Result<Movie, MovieParseError> {
        guard
            let json = try? NSJSONSerialization.JSONObjectWithData(
                data,
                options: []
            ),
            let movieObject = json as? [String: AnyObject],
            let movieId = movieObject["id"] as? Int,
            let movieTitle = movieObject["title"] as? String,
            let movieDirector = movieObject["director"] as? String else
        {
            return Result.Failure(MovieParseError.MalformedData)
        }

        return Result.Success(Movie(id: movieId, title: movieTitle, director: movieDirector))
    }
}
