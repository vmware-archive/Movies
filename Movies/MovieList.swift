struct MovieList {
    let movies: [Movie]
}

extension MovieList: Equatable {}

func ==(lhs: MovieList, rhs: MovieList) -> Bool {
    return lhs.movies == rhs.movies
}