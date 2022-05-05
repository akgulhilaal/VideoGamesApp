//
//  Game.swift
//  VideoGamesApp
//
//  Created by Hilal Akgül on 8.03.2022.
//

import Foundation

struct GameModel: Codable {
    var results = [GameList?]()
}

struct GameList: Codable{
    let slug: String?
    let name: String?
    let released: String?
    let background_image: String?
    let rating: Double?
}

