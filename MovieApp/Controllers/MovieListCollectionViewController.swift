//
//  MovieListCollectionViewController.swift
//  MovieApp
//
//  Created by Gasho on 01.04.2021..
//

import UIKit

final class MovieListCollectionViewController: UIViewController, Storyboarded {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var movieListType: MovieListEndpoint!
    
    private var movies: [Movie] = []
    private let itemsPerRow: CGFloat = 2
    private var currentPage = 1
    private var pageNumber = 1
    private var isLoadingMoreData = false
    private let sectionInsets = UIEdgeInsets(
        top: 20.0,
        left: 20.0,
        bottom: 20.0,
        right: 20.0
    )
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        fetchMovies()
    }
    
    private func setupView(){
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.collectionView.prefetchDataSource = self
        let cell = UINib(nibName: MovieListCollectionViewCell.identifier,
                         bundle: nil)
        self.collectionView!.register(cell,
                                      forCellWithReuseIdentifier: MovieListCollectionViewCell.identifier)
    }
    
    private func fetchMovies(forPage: Int = 1){
        isLoadingMoreData = true
        MovieService.fetchMovies(form: movieListType, page: currentPage) { [weak self] (result) in
            switch result{
            case .success(let movieResponse):
                self?.movies.append(contentsOf: movieResponse.movies)
                self?.pageNumber = movieResponse.totalPages
                self?.collectionView.reloadData()
                self?.isLoadingMoreData = false
            case .failure(let error):
                Helper.displayAlert("Error", error.localizedDescription, actionTitle: "Ok")
            }
        }
    }
}

// MARK: - UICollectionViewDataSource
extension MovieListCollectionViewController: UICollectionViewDataSource{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let movie = movies[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(MovieListCollectionViewCell.self)", for: indexPath) as! MovieListCollectionViewCell
        cell.udate(with: movie)
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension MovieListCollectionViewController: UICollectionViewDelegate{
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let movie = movies[indexPath.row]
        let movieDetailViewContoroller = MovieDetailsTableViewController.instantiate()
        movieDetailViewContoroller.hidesBottomBarWhenPushed = true
        movieDetailViewContoroller.movieID = movie.id
        self.navigationController?.pushViewController(movieDetailViewContoroller, animated: true)
    }
}

// MARK: - UICollectionViewDataSourcePrefetching
extension MovieListCollectionViewController: UICollectionViewDataSourcePrefetching{
    
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths{
            if indexPath.row >= movies.count - 5 && !isLoadingMoreData && currentPage <= pageNumber{
                currentPage = currentPage + 1
                self.fetchMovies(forPage: currentPage)
                break
            }
        }
    }
}
