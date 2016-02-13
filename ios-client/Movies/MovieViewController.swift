import UIKit
import BrightFutures

class MovieViewController: UIViewController {
    let movieRepository: MovieRepository
    var allMovies: MovieList
    let tableView: UITableView
    let refreshControl: UIRefreshControl

    // MARK: - init

    init(movieRepository: MovieRepository) {
        self.movieRepository = movieRepository
        self.allMovies = MovieList(movies: [])
        self.tableView = UITableView()
        self.refreshControl = UIRefreshControl()

        super.init(nibName: nil, bundle: nil)

        self.tableView.dataSource = self
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - view configuration

    override func loadView() {
        let bounds = UIScreen.mainScreen().bounds
        let frame = CGRect(
            x: bounds.origin.x,
            y: bounds.origin.y + statusBarHeight(),
            width: bounds.width,
            height: bounds.height
        )

        view = UIView(frame: frame)
        view.backgroundColor = UIColor.cyanColor()

        view.addSubview(tableView)
        tableView.frame = view.frame
        tableView.backgroundColor = UIColor.redColor()
        tableView.addSubview(refreshControl)
        refreshControl.addTarget(
            self,
            action: "didPullToRefresh",
            forControlEvents: UIControlEvents.ValueChanged
        )

        loadMovieData()
    }

    func didPullToRefresh() {
        self.refreshControl.beginRefreshing()

        loadMovieData().onSuccess { [unowned self] _ in
            self.refreshControl.endRefreshing()
        }
    }

    private func loadMovieData() -> Future<MovieList, RepositoryError> {
        return movieRepository.getAll().onSuccess { [unowned self] movieList in
            self.allMovies = movieList
            self.tableView.reloadData()
        }
    }

    private func statusBarHeight() -> CGFloat {
        let statusBarSize = UIApplication.sharedApplication().statusBarFrame.size
        return min(statusBarSize.width, statusBarSize.height)
    }
}

// MARK: - UITableViewDataSource
extension MovieViewController: UITableViewDataSource {
    func tableView(
        tableView: UITableView,
        numberOfRowsInSection section: Int
        ) -> Int
    {
        return allMovies.movies.count
    }

    func tableView(
        tableView: UITableView,
        cellForRowAtIndexPath indexPath: NSIndexPath
        ) -> UITableViewCell
    {
        let cell = UITableViewCell()
        cell.textLabel?.text = allMovies.movies[indexPath.row].title
        return cell
    }
}
