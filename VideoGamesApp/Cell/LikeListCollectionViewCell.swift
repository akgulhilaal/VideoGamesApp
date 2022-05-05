//
//  LikeListCollectionViewCell.swift
//  VideoGamesApp
//
//  Created by Hilal Akgül on 10.03.2022.
//

import UIKit

class LikeListCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var likedNameLabel: UILabel!
    @IBOutlet weak var likedImage: UIImageView!
    @IBOutlet weak var likedReleasedRatingLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func configure(model : DetailsModel){
        let url = URL(string: (model.background_image))
        let data = try? Data(contentsOf: url!)
        if let imageData = data {
            self.likedImage.image = UIImage(data: imageData)
        }
        self.likedNameLabel.text = model.name
        self.likedReleasedRatingLabel.text = "\(model.rating)-\(model.released)"
    }

}
