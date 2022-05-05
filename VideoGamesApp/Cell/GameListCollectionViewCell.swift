//
//  GameListCollectionViewCell.swift
//  VideoGamesApp
//
//  Created by Hilal Akgül on 6.03.2022.
//

import UIKit

class GameListCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var gameNameLabel: UILabel!
    @IBOutlet weak var gameImage: UIImageView!
    @IBOutlet weak var gameReleasedRatingLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
