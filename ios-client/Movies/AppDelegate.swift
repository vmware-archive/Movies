import UIKit

class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(
        application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?
        ) -> Bool
    {
        let movieRepository = NetworkMovieRepository(
            http: NetworkHttp(session: ConfiguredNetworkSession()),
            parser: MovieListParser()
        )

        let movieViewController = MovieViewController(
            movieRepository: movieRepository
        )

        window = UIWindow()
        window?.rootViewController = movieViewController
        window?.makeKeyAndVisible()

        return true
    }
}
