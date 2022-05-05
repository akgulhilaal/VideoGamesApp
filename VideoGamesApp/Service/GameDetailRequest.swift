//
//  GameDetailRequest.swift
//  VideoGamesApp
//
//  Created by Hilal Akgül on 9.03.2022.
//

import Foundation

enum GameDetailRequestError: Error {
    case noDataAvailable
    case canNotProcessData
}

struct GameDetailRequest {
    
    let resourceURL: URL
    static var slug = ""
    
    init() {
        let resourceString = "https://api.rawg.io/api/games/\(GameDetailRequest.slug)?key=b4520fa1e40943148bfcc73dffd4fce6"
        guard let resourceURL = URL(string: resourceString) else {
            fatalError("Error")
        }
        self.resourceURL = resourceURL
    }
    func getDetails(completion : @escaping(Result<DetailsModel,GameDetailRequestError>) -> Void){
        let dataTask = URLSession.shared.dataTask(with: resourceURL) { data, response, error in
            
            guard let jsonData = data else {
                completion(.failure(.noDataAvailable))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let details = try decoder.decode(DetailsModel.self, from: jsonData)
                completion(.success(details))
            } catch {
                completion(.failure(.canNotProcessData))
            }
        }
        dataTask.resume()
    }
    
    
}


