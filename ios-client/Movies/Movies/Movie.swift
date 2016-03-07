struct Movie {
    let id: Int
    let title: String
}

extension Movie: Equatable {}

func ==(lhs: Movie, rhs: Movie) -> Bool {
    return lhs.id == rhs.id && lhs.title == rhs.title
}
