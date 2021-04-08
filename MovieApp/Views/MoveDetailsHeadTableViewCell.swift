//
//  MoveDetailsHeadTableViewCell.swift
//  MovieApp
//
//  Created by Gasho on 06.04.2021..
//

import UIKit

class MoveDetailsHeadTableViewCell: UITableViewCell, CellIdentifier {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var collectionView: UICollectionView!
    
    static let identifier = "\(MoveDetailsHeadTableViewCell.self)"
    
    var movie: Movie!  {
        didSet{
            titleLabel.text = movie.title
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupViews()
    }

    private func setupViews(){
        collectionView.dataSource = self
        collectionView.delegate = self
        let cell = UINib(nibName: MovieListCollectionViewCell.identifier,
                         bundle: nil)
        self.collectionView!.register(cell,
                                      forCellWithReuseIdentifier: MovieListCollectionViewCell.identifier)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

// MARK: - UICollectionViewDataSource
extension MoveDetailsHeadTableViewCell: UICollectionViewDataSource{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let movie = movie else{
            return UICollectionViewCell()
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(MovieListCollectionViewCell.self)", for: indexPath) as! MovieListCollectionViewCell
        if indexPath.section == 0{
            cell.updateMovieHeaderCell(with: movie.posterPathURL)
        }else{
            cell.updateMovieHeaderCell(with: movie.backDropPathURL)
        }
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout, UICollectionViewDelegate
extension MoveDetailsHeadTableViewCell: UICollectionViewDelegateFlowLayout, UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if indexPath.section == 0 {
            return CGSize(width: 165, height: 250)
        }else{
            return CGSize(width: contentView.frame.size.width - 20, height: 250)
        }
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int
    ) -> UIEdgeInsets {
        
        if section == 0 {
            let totalCellWidth = 165
            let totalSpacingWidth = 10 * (collectionView.numberOfItems(inSection: 0) - 1)
            let leftInset = (collectionView.layer.frame.size.width - CGFloat(totalCellWidth + totalSpacingWidth)) / 2
            let rightInset = leftInset
            return UIEdgeInsets(top: 0, left: leftInset, bottom: 0, right: rightInset)
        }else{
            return UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageIndex = round(scrollView.contentOffset.x/contentView.frame.width)
        pageControl.currentPage = Int(pageIndex)
    }
}
