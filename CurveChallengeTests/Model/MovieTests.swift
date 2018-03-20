//
//  MovieTests.swift
//  CurveChallengeTests
//
//  Created by Sam Watts on 20/03/2018.
//  Copyright © 2018 Sam Watts. All rights reserved.
//

import XCTest
@testable import CurveChallenge

class MovieTests: XCTestCase {

    func testMovieCanBeMappedFromSingleResponse() {
        let data = testData(fromFixtureNamed: "single_movie")
        do {
            let movie = try JSONDecoder.movieDecoder.decode(Movie.self, from: data)
            XCTAssertEqual(movie.identifier, 269149)
            XCTAssertEqual(movie.originalTitle, "Zootopia")
            XCTAssertEqual(movie.releaseDate, Date(timeIntervalSince1970: 1455148800))
            XCTAssertEqual(movie.posterPath, "/sM33SANp9z6rXW8Itn7NnG1GOEs.jpg")
            XCTAssertEqual(movie.overview, "Determined to prove herself, Officer Judy Hopps, the first bunny on Zootopia's police force, jumps at the chance to crack her first case - even if it means partnering with scam-artist fox Nick Wilde to solve the mystery.")
            XCTAssertEqual(movie.voteAverage, 7.7)
        } catch {
            XCTFail("Unexpected error mapping movie: \(error)")
        }
    }

    func testEqualityChecksIdentifier() {
        let movieA = Movie(identifier: 1, originalTitle: "title", releaseDate: Date(), posterPath: "path", overview: "overview", voteAverage: 12)
        let movieB = Movie(identifier: 1, originalTitle: "different title", releaseDate: Date(timeIntervalSince1970: 0), posterPath: "different path", overview: "different overview", voteAverage: 1223)

        XCTAssertEqual(movieA, movieB)
    }
}
