//
//  GameResultRequest.swift
//  VideoGamesApp
//
//  Created by Hilal Akgül on 8.03.2022.
//

import Foundation

enum GameResultRequestError: Error {
    case noDataAvailable
    case canNotProcessData
}
struct GameResultRequest {
    
    let resourceURL: URL
    
    init() {
        let resourceString = "https://api.rawg.io/api/games?key=b4520fa1e40943148bfcc73dffd4fce6"
        guard let resourceURL = URL(string: resourceString) else {
            fatalError("Error")
        }
        self.resourceURL = resourceURL
    }
    func getGames(completion : @escaping(Result<GameModel,GameResultRequestError>) -> Void){
        let dataTask = URLSession.shared.dataTask(with: resourceURL) { data, response, error in
            
            guard let jsonData = data else {
                completion(.failure(.noDataAvailable))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let games = try decoder.decode(GameModel.self, from: jsonData)
                completion(.success(games))
            } catch {
                completion(.failure(.canNotProcessData))
            }
        }
        dataTask.resume()
    }
    
}



