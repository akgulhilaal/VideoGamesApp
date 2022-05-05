//
//  DetailsModel.swift
//  VideoGamesApp
//
//  Created by Hilal Akgül on 9.03.2022.
//

import Foundation

struct DetailsModel: Codable {
    let metacritic: Int
    let rating: Double
    let name: String
    let slug : String
    let description_raw: String
    let background_image: String
    let released: String
}

extension DetailsModel: Equatable {
}
