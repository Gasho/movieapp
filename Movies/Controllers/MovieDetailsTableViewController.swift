//
//  MovieDetailsTableViewController.swift
//  MovieApp
//
//  Created by Gasho on 06.04.2021.
//

import UIKit

class MovieDetailsTableViewController: UITableViewController, Storyboarded {

    var movieID: Int!
    
    // Closure to reload collectionView in cell when more similar movies are loaded
    var updateSimilarMovies: ([Movie]) -> () = {_ in }
    
    private var currentPage = 1
    private var totalPages = 1
    private var isLoadingMoreData = false
    private var movie: Movie! {
        didSet{
            self.tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        fetchMovie()
    }
    
    private func setupView(){
        self.tableView.tableFooterView = UIView()
        self.navigationItem.largeTitleDisplayMode = .never
        let cell = UINib(nibName: MoveDetailsHeadTableViewCell.identifier,
                         bundle: nil)
        self.tableView.register(cell,
                                forCellReuseIdentifier: MoveDetailsHeadTableViewCell.identifier)
        
        let textCell = UINib(nibName: MovieDetailTextTableViewCell.identifier,
                         bundle: nil)
        self.tableView.register(textCell,
                                forCellReuseIdentifier: MovieDetailTextTableViewCell.identifier)
        let collectionCell = UINib(nibName: MovieDetailsSimilarMoviesTableViewCell.identifier,
                         bundle: nil)
        self.tableView.register(collectionCell,
                                forCellReuseIdentifier: MovieDetailsSimilarMoviesTableViewCell.identifier)
    }
    
    // Loads additional movie data and triggers initial similar movie load
    private func fetchMovie(){
        MovieService.fetchMovie(with: movieID) { [weak self] (result) in
            switch result{
            case .success(var movie):
                self?.fetchSimilarMovies(forPage: self?.currentPage ?? 1, completion: { [weak self] (movies) in
                    movie.similarMovies.append(contentsOf: movies)
                    self?.movie = movie
                })
            case .failure(let error):
                Helper.displayAlert("Error", error.localizedDescription, actionTitle: "Ok")
            }
        }
    }
    
    // Loads similar movies depending on current page
    private func fetchSimilarMovies(forPage: Int = 1, completion: (([Movie]) -> ())? = nil){
        isLoadingMoreData = true
        MovieService.fetchMovies(form: MovieListEndpoint.similar(movieID), page: currentPage) { [weak self] (result) in
            switch result{
            case .success(let movieResponse):
                self?.totalPages = movieResponse.totalPages
                self?.isLoadingMoreData = false
                if let comp = completion {
                    comp(movieResponse.movies)
                    return
                }
                self?.movie.similarMovies.append(contentsOf: movieResponse.movies)
                self?.updateSimilarMovies(movieResponse.movies)
                
            case .failure(let error):
                Helper.displayAlert("Error", error.localizedDescription, actionTitle: "Ok")
            }
        }
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        guard let movie = movie else {
            return 0
        }
        if movie.similarMovies.isEmpty{
            return 2
        }
        return 3
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section{
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: MoveDetailsHeadTableViewCell.identifier, for: indexPath) as? MoveDetailsHeadTableViewCell, let movie = movie else{
                return UITableViewCell()
            }
            cell.movie = movie
            return cell
        
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: MovieDetailTextTableViewCell.identifier, for: indexPath) as? MovieDetailTextTableViewCell, let movie = movie else{
                return UITableViewCell()
            }
            cell.setupCell(with: movie.detailTextData[indexPath.row])
            return cell
            
        default:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: MovieDetailsSimilarMoviesTableViewCell.identifier , for: indexPath) as? MovieDetailsSimilarMoviesTableViewCell else{
                return UITableViewCell()
            }
            
            // Setting closure to point on cell
            self.updateSimilarMovies = cell.setupCell(with: "Similar movies: ", collectionView: self)
            return cell
        }
    }
}

extension MovieDetailsTableViewController: UICollectionViewDataSourcePrefetching{
    
    // Loads more similar movies when scorlling
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths{
            if indexPath.row >= movie.similarMovies.count - 5 && !isLoadingMoreData && currentPage <= totalPages{
                currentPage += 1
                self.fetchSimilarMovies(forPage: currentPage)
                break
            }
        }
    }
}

extension MovieDetailsTableViewController: UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movie.similarMovies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let movie = self.movie.similarMovies[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(MovieListCollectionViewCell.self)", for: indexPath) as! MovieListCollectionViewCell
        cell.udate(with: movie)
        return cell
    }
}

extension MovieDetailsTableViewController: UICollectionViewDelegate{
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let movie = self.movie.similarMovies[indexPath.row]
        let movieDetailsViewController = MovieDetailsTableViewController.instantiate()
        movieDetailsViewController.movieID = movie.id
        self.navigationController?.pushViewController(movieDetailsViewController, animated: true)
    }
}

extension MovieDetailsTableViewController: UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 125, height: 190)
    }
}
