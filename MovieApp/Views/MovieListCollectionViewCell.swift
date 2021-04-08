//
//  MoviewListCollectionViewCell.swift
//  MovieApp
//
//  Created by Gasho on 01.04.2021..
//

import UIKit
import SDWebImage

protocol CellIdentifier{
    static var identifier: String { get }
}

class MovieListCollectionViewCell: UICollectionViewCell, CellIdentifier {

    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    static let identifier = "\(MovieListCollectionViewCell.self)"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupViews()
    }
    
    private func setupViews(){
        titleLabel.textColor = .white
        titleLabel.backgroundColor = .blackAlpha
        titleLabel.numberOfLines = 5
        titleLabel.lineBreakMode = .byWordWrapping
        titleLabel.textAlignment = .left
    }
    
    func udate(with movie: Movie){
        titleLabel.text = movie.title
        backgroundImageView.sd_setImage(with: movie.posterPathURL, placeholderImage: UIImage(systemName: "text.below.photo"))
    }
    
    func updateMovieHeaderCell(with imageURL:URL){
        titleLabel.isHidden = true
        backgroundImageView.sd_setImage(with: imageURL, placeholderImage: UIImage(systemName: "text.below.photo"))
    }
}
