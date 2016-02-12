import Foundation

struct MovieParser {
    func parse(data: NSData) -> Movie? {
        guard
            let json = try? NSJSONSerialization.JSONObjectWithData(
                data,
                options: []
            ),
            let movieObject = json as? [String: AnyObject],
            let movieId = movieObject["id"] as? Int,
            let movieTitle = movieObject["title"] as? String else
        {
            return nil
        }

        return Movie(id: movieId, title: movieTitle)
    }
}
