//
//  LikedViewController.swift
//  VideoGamesApp
//
//  Created by Hilal Akgül on 6.03.2022.
//

import UIKit

class LikedViewController: UIViewController {
    static var gameNames = [String]()
    static var likes = [DetailsModel]()
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Do any additional setup after loading the view.
        collectionView.register(UINib(nibName: "LikeListCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "LikeCell")
    }
    override func viewWillAppear(_ animated: Bool) {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
            
        }
    }
    
}
extension LikedViewController : UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width * 0.95, height: collectionView.frame.height * 0.2)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return LikedViewController.likes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LikeCell", for: indexPath) as! LikeListCollectionViewCell
        cell.configure(model: LikedViewController.likes[indexPath.row])
        cell.layer.borderColor = UIColor.systemOrange.cgColor
        cell.layer.borderWidth = 1
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        GameDetailRequest.slug = LikedViewController.likes[indexPath.row].slug
        self.performSegue(withIdentifier: "likeDetails", sender: self)
    }
    
}
