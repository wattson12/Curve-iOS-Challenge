//
//  Movie.swift
//  CurveChallenge
//
//  Created by Sam Watts on 20/03/2018.
//  Copyright © 2018 Sam Watts. All rights reserved.
//

import Foundation

struct Movie: Decodable {
    private enum CodingKeys: String, CodingKey {
        case identifier = "id"
        case originalTitle = "original_title"
        case releaseDate = "release_date"
        case posterPath = "poster_path"
        case overview
        case voteAverage = "vote_average"
    }

    let identifier: Int
    let originalTitle: String
    let releaseDate: Date
    let posterPath: String
    let overview: String
    let voteAverage: Double
}

extension Movie: Equatable {

    static func == (lhs: Movie, rhs: Movie) -> Bool {
        return lhs.identifier == rhs.identifier
    }
}
