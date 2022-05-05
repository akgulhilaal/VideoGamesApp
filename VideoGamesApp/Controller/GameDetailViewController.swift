//
//  GameDetailViewController.swift
//  VideoGamesApp
//
//  Created by Hilal Akgül on 6.03.2022.
//

import UIKit

class GameDetailViewController: UIViewController {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var releaseLabel: UILabel!
    @IBOutlet weak var rateLabel: UILabel!
    @IBOutlet weak var gameImage: UIImageView!
    
    @IBOutlet weak var likeButton: UIButton!
    
    @IBOutlet weak var descriptionText: UITextView!
    
    var detailList : DetailsModel?{
        didSet{
            DispatchQueue.main.async {
                self.nameLabel.text = (self.detailList?.name)!
                self.releaseLabel.text = (self.detailList?.released)!
                self.rateLabel.text = "\((self.detailList?.metacritic)!) - \((self.detailList?.rating)!)"
                self.descriptionText.text = (self.detailList?.description_raw)!
                
                let url = URL(string: (self.detailList?.background_image)!)
                let data = try? Data(contentsOf: url!)
                if let imageData = data {
                    self.gameImage.image = UIImage(data: imageData)
                }
                
                if LikedViewController.gameNames.contains(self.nameLabel.text!){
                    self.likeButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
                }
                
            }
            
        }
    }
    
    @IBAction func addFavorites(_ sender: Any) {
        if !LikedViewController.gameNames.contains(nameLabel.text!){
            LikedViewController.gameNames.append(nameLabel.text!)
            LikedViewController.likes.append(detailList!)
            likeButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            
        }
        else{
            let dialogMessage = UIAlertController(title: "Confirm", message: "Are you sure you want to delete this from favorites ?", preferredStyle: .alert)
            
            let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
                if let index = LikedViewController.likes.firstIndex(of: self.detailList!) {
                    LikedViewController.likes.remove(at: index)
                }
                if let index = LikedViewController.gameNames.firstIndex(of: self.nameLabel.text!) {
                    LikedViewController.gameNames.remove(at: index)
                }
                self.likeButton.setImage(UIImage(systemName: "heart"), for: .normal)
            })
            
            let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) -> Void in
            }
            
            dialogMessage.addAction(ok)
            dialogMessage.addAction(cancel)
            
            self.present(dialogMessage, animated: true, completion: nil)
            
        }
        
    }
    
    let gameDetailRequest = GameDetailRequest()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        gameDetailRequest.getDetails { result in
            switch result {
            case .success(let detailList):
                self.detailList = detailList
            case .failure(let error):
                print(error.localizedDescription)
            }
            
        }
        gameImage.layer.borderColor = UIColor.systemIndigo.cgColor
        gameImage.layer.borderWidth = 1
        nameLabel.layer.borderColor = UIColor.systemOrange.cgColor
        nameLabel.layer.borderWidth = 1
        releaseLabel.layer.borderColor = UIColor.systemIndigo.cgColor
        releaseLabel.layer.borderWidth = 1
        rateLabel.layer.borderColor = UIColor.systemOrange.cgColor
        rateLabel.layer.borderWidth = 1
        descriptionText.layer.borderColor = UIColor.systemIndigo.cgColor
        descriptionText.layer.borderWidth = 1
        
        
        
    }
    
}

