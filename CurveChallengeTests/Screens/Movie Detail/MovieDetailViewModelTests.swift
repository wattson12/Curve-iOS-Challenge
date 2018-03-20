//
//  MovieDetailViewModelTests.swift
//  CurveChallengeTests
//
//  Created by Sam Watts on 20/03/2018.
//  Copyright © 2018 Sam Watts. All rights reserved.
//

import XCTest
@testable import CurveChallenge
import RxSwift
import RxCocoa

class MovieDetailViewModelTests: XCTestCase {
    
    func testInitMovieIsBoundToObservable() {
        let originalMovie = Movie(identifier: 1, originalTitle: "title", releaseDate: Date(timeIntervalSince1970: 100), posterPath: "poster path", overview: "overview", voteAverage: 12)

        let viewModel = MovieDetailViewModel(movie: originalMovie)

        XCTAssertEqual(viewModel.movie.value.identifier, originalMovie.identifier)
    }
    
}
