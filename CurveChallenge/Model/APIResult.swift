//
//  APIResult.swift
//  CurveChallenge
//
//  Created by Sam Watts on 20/03/2018.
//  Copyright © 2018 Sam Watts. All rights reserved.
//

import Foundation

struct APIResult<T: Decodable>: Decodable {
    private enum CodingKeys: String, CodingKey {
        case page
        case totalResults = "total_results"
        case totalPages = "total_pages"
        case results
    }

    let page: Int
    let totalResults: Int
    let totalPages: Int
    let results: [T]
}
