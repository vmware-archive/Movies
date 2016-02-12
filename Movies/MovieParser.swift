import Foundation

import Result

struct Movie {
    let id: Int
    let title: String
}

extension Movie: Equatable {}

enum ParseError: ErrorType {
    case MissingKey
}

func ==(lhs: Movie, rhs: Movie) -> Bool {
    return lhs.id == rhs.id && lhs.title == rhs.title
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
