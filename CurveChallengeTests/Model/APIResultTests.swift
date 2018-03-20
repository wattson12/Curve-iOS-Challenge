//
//  APIResultTests.swift
//  CurveChallengeTests
//
//  Created by Sam Watts on 20/03/2018.
//  Copyright © 2018 Sam Watts. All rights reserved.
//

import XCTest
@testable import CurveChallenge

class APIResultTests: XCTestCase {
    
    func testMappingFullResponseReturnsPagingInfoAndResults() {
        let data = testData(fromFixtureNamed: "full_response")
        do {
            let result = try JSONDecoder.movieDecoder.decode(APIResult<Movie>.self, from: data)
            XCTAssertEqual(result.page, 1)
            XCTAssertEqual(result.totalResults, 19883)
            XCTAssertEqual(result.totalPages, 995)
            XCTAssertEqual(result.results.count, 20)
        } catch {
            XCTFail("Unexpected error mapping API results: \(error)")
        }
    }
    
}
