struct Movie {
    let id: Int
    let title: String
    let director: String
}

extension Movie: Equatable {}

func ==(lhs: Movie, rhs: Movie) -> Bool {
    return lhs.id == rhs.id &&
        lhs.title == rhs.title &&
        lhs.director == rhs.director
}
