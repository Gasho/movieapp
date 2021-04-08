//
//  MovieDetailsSimilarMoviesTableViewCell.swift
//  MovieApp
//
//  Created by Gasho on 06.04.2021..
//

import UIKit

class MovieDetailsSimilarMoviesTableViewCell: UITableViewCell, CellIdentifier {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var titleLabel: UILabel!
    
    static let identifier = "\(MovieDetailsSimilarMoviesTableViewCell.self)"
    
    private var reloadCollectionView: (([Movie]) -> ()) = { _ in }

    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }

    private func setupView(){
        let cell = UINib(nibName: MovieListCollectionViewCell.identifier,
                         bundle: nil)
        self.collectionView!.register(cell,
                                      forCellWithReuseIdentifier: MovieListCollectionViewCell.identifier)
        
        reloadCollectionView = { [weak self] similarMovies in
            self?.collectionView.reloadData()
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setupCell(with title:String, collectionView delegate: MovieDetailsTableViewController) -> (([Movie]) -> ()){
        collectionView.prefetchDataSource = delegate
        collectionView.dataSource = delegate
        collectionView.delegate = delegate
        titleLabel.text = title
        return reloadCollectionView
    }
}
