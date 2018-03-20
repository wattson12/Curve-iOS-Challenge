//
//  URL+Construction.swift
//  CurveChallenge
//
//  Created by Sam Watts on 20/03/2018.
//  Copyright © 2018 Sam Watts. All rights reserved.
//

import Foundation

private let movieDBAPIKey = "bac74eeba9b1cb0b0869b42a7647e79f"

extension URL {

    static func popularMovies(forPage page: Int) -> URL {
        guard let url = URL(string: "https://api.themoviedb.org/3/movie/popular?api_key=\(movieDBAPIKey)&page=\(page)") else {
            fatalError("Unable to create popular movie URL")
        }

        return url
    }

    static func poster(withPath posterPath: String) -> URL? {
        return URL(string: "https://image.tmdb.org/t/p/w500/" + posterPath)
    }
}
