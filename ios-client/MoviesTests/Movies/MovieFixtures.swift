@testable import Movies

class MovieFixtures {
    static func newMovie(
        id: Int = 1,
        title: String = "The Shining",
        director: String = "Stanley Kubrick"
        ) -> Movie
    {
        return Movie(id: id, title: title, director: director)
    }
}