//
//  MovieDetailTextTableViewCell.swift
//  MovieApp
//
//  Created by Gasho on 06.04.2021..
//

import UIKit

class MovieDetailTextTableViewCell: UITableViewCell, CellIdentifier {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    static let identifier = "\(MovieDetailTextTableViewCell.self)"
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
        
    func setupCell(with movieTextData: (title: String, description: String)){
        self.titleLabel.text = movieTextData.title
        self.descriptionLabel.text = movieTextData.description
    }
}
