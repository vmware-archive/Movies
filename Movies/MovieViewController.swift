import UIKit

class MovieViewController: UIViewController {
    let movieRepository: MovieRepository
    var allMovies: MovieList
    let tableView: UITableView

    // MARK: - init

    init(movieRepository: MovieRepository) {
        self.movieRepository = movieRepository
        self.allMovies = MovieList(movies: [])
        self.tableView = UITableView()

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

        movieRepository.getAll().onSuccess { [unowned self] movieList in
            self.allMovies = movieList
            self.tableView.reloadData()
        }
    }

    private func statusBarHeight() -> CGFloat {
        let statusBarSize = UIApplication.sharedApplication().statusBarFrame.size
        return min(statusBarSize.width, statusBarSize.height)
    }
}

// MARK: - tableView
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
