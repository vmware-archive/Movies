struct Environment {
    static var apiEndpoint: String {
        #if PRODUCTION
            return "http://localhost:8080"
        #elseif ACCEPTANCE
            return "http://localhost:8080"
        #else // DEVELOPMENT
            return "http://localhost:8080"
        #endif
    }
}