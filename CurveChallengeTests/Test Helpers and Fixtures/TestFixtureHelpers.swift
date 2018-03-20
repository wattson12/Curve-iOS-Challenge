//
//  TestFixtureHelpers.swift
//  CurveChallengeTests
//
//  Created by Sam Watts on 20/03/2018.
//  Copyright © 2018 Sam Watts. All rights reserved.
//

import XCTest

//Dummy class used to get the test bundle
class BundleLocatorClass { }

func testData(fromFixtureNamed fixtureName: String, file: StaticString = #file, line: UInt = #line) -> Data {
    guard let jsonPath = Bundle(for: BundleLocatorClass.self).path(forResource: fixtureName, ofType: "json") else {
        XCTFail("Unable to find \(fixtureName).json in test bundle", file: file, line: line)
        return Data()
    }

    guard let data = try? Data(contentsOf: URL(fileURLWithPath: jsonPath)) else {
        XCTFail("Contents of \(fixtureName).json is invalid data", file: file, line: line)
        return Data()
    }

    return data
}
