import Foundation

import Result

enum ParseError: ErrorType {
    case MissingKey
}

struct MovieParser {
    func parse(data: NSData) -> Result<Movie, ParseError> {
        guard
            let json = try? NSJSONSerialization.JSONObjectWithData(
                data,
                options: []
            ),
            let movieObject = json as? [String: AnyObject],
            let movieId = movieObject["id"] as? Int,
            let movieTitle = movieObject["title"] as? String else
        {
            return Result.Failure(.MissingKey)
        }

        return Result.Success(
            Movie(id: movieId, title: movieTitle)
        )
    }
}
