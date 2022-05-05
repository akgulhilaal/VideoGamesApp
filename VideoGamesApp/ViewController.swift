//
//  ViewController.swift
//  VideoGamesApp
//
//  Created by Hilal Akgül on 6.03.2022.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var sliderCollectionView: UICollectionView!
    @IBOutlet weak var pageView: UIPageControl!
    @IBOutlet weak var sliderStack: UIStackView!
    @IBOutlet weak var collectionViewStack: UIStackView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var gameList = GameModel() {
        didSet {
            DispatchQueue.main.async {
                self.collectionView.reloadData()
                self.sliderCollectionView.reloadData()
                self.pageView.addTarget(self, action: #selector(self.pagecontrollervalues(_:)), for: .valueChanged)
            }
        }
    }
    
    var filteredGames = [GameList?]()
    var isFiltering: Bool = false
    var currentPageIndex = 0
    let gameRequest = GameResultRequest()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        gameRequest.getGames { result in
            switch result {
            case .success(let gameList):
                self.gameList = gameList
            case .failure(let error):
                print(error.localizedDescription)
            }
            
        }
        
        sliderCollectionView.delegate = self
        sliderCollectionView.dataSource = self
  
        tabbarConfig()
        
        collectionView.register(UINib(nibName: "GameListCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "GameCell")
        collectionView.register(UINib(nibName: "EmptyCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "EmptyCell")
        
    }
    @objc func imageChanges(_ sender : UIPageControl){
        if currentPageIndex < 2{
            currentPageIndex += 1
        }
        else{
            currentPageIndex = 0
        }
        let indexPath = IndexPath.init(row: currentPageIndex, section: 0)
        self.sliderCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        pageView.currentPage = currentPageIndex
    }
    
    @objc func pagecontrollervalues(_ sender : UIPageControl){
        let index = sender.currentPage
        let indexPath = IndexPath.init(row: index, section: 0)
        currentPageIndex = index
        self.sliderCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        pageView.currentPage = currentPageIndex
    }
    
    private func tabbarConfig() {
        guard let tabbar = tabBarController?.tabBar else { return }
        tabbar.layer.borderWidth = 0.3
        tabbar.layer.borderColor = UIColor.systemGray.cgColor
        
    }
}

extension ViewController : UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if collectionView == self.collectionView {
            let offset = scrollView.contentOffset.x
            let width = scrollView.frame.width
            let horizontalCenter = width / 2
            pageView.currentPage = Int(offset + horizontalCenter) / Int(width)
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == self.collectionView {
            return CGSize(width: collectionView.frame.width * 0.95, height: 100)
        }
        else {
            return CGSize(width: collectionView.frame.width , height: collectionView.frame.height)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == sliderCollectionView{
            var count = 0
            if gameList.results.count > 3{
                count = 3
            }
            else{
                
                count = gameList.results.count
            }
            
            return count
            
        }
        if isFiltering{
            if filteredGames.count == 0{
                return 1
            }
            else {
                return filteredGames.count
            }
        }
        return gameList.results.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        var gameData = gameList.results[indexPath.row]
        if collectionView == sliderCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath) as! SliderCollectionViewCell
            cell.layer.borderColor = UIColor.systemOrange.cgColor
            cell.layer.borderWidth = 1
            let url = URL(string: (gameData?.background_image)!)
            let data = try? Data(contentsOf: url!)
            
            if let imageData = data {
                cell.sliderImage.image = UIImage(data: imageData)
            }
            return cell
            
        }
        else{
            if isFiltering{
                if filteredGames.count == 0{
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EmptyCell", for: indexPath) as! EmptyCollectionViewCell
                    
                    return cell
                }else{
                    gameData = filteredGames[indexPath.row]
                }
            }else{
                gameData =  gameList.results[indexPath.row]
            }
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GameCell", for: indexPath) as! GameListCollectionViewCell
            cell.layer.borderColor = UIColor.systemIndigo.cgColor
            cell.layer.borderWidth = 1
            
            
            let url = URL(string: (gameData?.background_image)!)
            let data = try? Data(contentsOf: url!)
            
            if let imageData = data {
                cell.gameImage.image = UIImage(data: imageData)
            }
            
            cell.gameNameLabel.text = gameData?.name
            cell.gameReleasedRatingLabel.text = "\((gameData?.rating)!)-\((gameData?.released)!)"
            return cell
            
        }
        
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if isFiltering{
            if filteredGames.count != 0{
                GameDetailRequest.slug = (gameList.results[indexPath.row]?.slug)!
                
                self.performSegue(withIdentifier: "sendData", sender: self)
            }
        }
        else{
            GameDetailRequest.slug = (gameList.results[indexPath.row]?.slug)!
            
            self.performSegue(withIdentifier: "sendData", sender: self)
        }
        
        
    }
    
}
extension ViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == ""{
            isFiltering = false
            self.collectionView.reloadData()
        }
        else if searchText.count >= 3{
            filteredGames = gameList.results.filter({ (game : GameList!) -> Bool in
                return (game.name?.lowercased().contains(searchText.lowercased()))!
            })
            
            isFiltering = true
            self.collectionView.reloadData()
        }
        sliderStack.isHidden = isFiltering
        
        
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.endEditing(true)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        isFiltering = false
        self.searchBar.text = ""
        self.collectionView.reloadData()
        self.searchBar.endEditing(true)
        sliderStack.isHidden = isFiltering

    }
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        self.searchBar.endEditing(true)
    }
}

