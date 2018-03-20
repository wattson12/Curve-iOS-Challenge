//
//  URL+ConstructionTests.swift
//  CurveChallengeTests
//
//  Created by Sam Watts on 20/03/2018.
//  Copyright © 2018 Sam Watts. All rights reserved.
//

import XCTest
@testable import CurveChallenge

class URL_ConstructionTests: XCTestCase {
    
    func testPopularMoviesURLIsCorrect() {
        let url = URL.popularMovies(forPage: 12, apiKey: "key")
        XCTAssertEqual(url.absoluteString, "https://api.themoviedb.org/3/movie/popular?api_key=key&page=12")
    }

    func testPosterURLIsCorrect() {
        let url = URL.poster(withPath: "test_path")
        XCTAssertEqual(url?.absoluteString, "https://image.tmdb.org/t/p/w500/test_path")
    }
    
}
