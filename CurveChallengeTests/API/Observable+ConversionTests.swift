//
//  Observable+ConversionTests.swift
//  CurveChallengeTests
//
//  Created by Sam Watts on 20/03/2018.
//  Copyright © 2018 Sam Watts. All rights reserved.
//

import XCTest
@testable import CurveChallenge
import RxSwift

struct DummyType: Codable {
    let identifier: Int
    let value: String
}

class Observable_ConversionTests: XCTestCase {
    
    let disposeBag = DisposeBag()

    func testDecodableTypeCanBeConvertedFromData() {
        let originalType = DummyType(identifier: 1, value: "value")
        guard let data = try? JSONEncoder().encode(originalType) else {
            XCTFail("Unable to encode dummy type")
            return
        }

        let conversionCompleted = expectation(description: "conversion stream completed")

        Observable
            .just(data)
            .convert(to: DummyType.self)
            .subscribe { event in
                switch event {
                case .next(let converted):
                    XCTAssertEqual(converted.identifier, 1)
                    XCTAssertEqual(converted.value, "value")
                case .error(let error):
                    XCTFail("Unexpected error after conversion: \(error)")
                case .completed:
                    conversionCompleted.fulfill()
                }
            }
            .disposed(by: disposeBag)

        waitForExpectations(timeout: 0.05)
    }

    func testFullAPIResponseCanBeConverted() {

        let data = testData(fromFixtureNamed: "full_response")

        let conversionCompleted = expectation(description: "conversion stream completed")

        Observable
            .just(data)
            .convert(to: APIResult<Movie>.self)
            .subscribe { event in
                switch event {
                case .next(let apiResult):
                    XCTAssertEqual(apiResult.page, 1)
                    XCTAssertEqual(apiResult.results.count, 20)
                case .error(let error):
                    XCTFail("Unexpected error after conversion: \(error)")
                case .completed:
                    conversionCompleted.fulfill()
                }
            }
            .disposed(by: disposeBag)

        waitForExpectations(timeout: 0.05)
    }

    func testErrorsInConversionArePassedThroughConversion() {

        let conversionCompleted = expectation(description: "conversion stream completed")

        let originalError = NSError(domain: #function, code: #line, userInfo: nil)
        Observable<Data>
            .error(originalError)
            .convert(to: APIResult<Movie>.self)
            .subscribe { event in
                switch event {
                case .next:
                    XCTFail("Unexpected succesful mapping")
                case .error(let error as NSError):
                    XCTAssertEqual(error, originalError)
                    conversionCompleted.fulfill()
                case .completed:
                    XCTFail("Unexpected completion (errored streams don't complete")
                }
            }
            .disposed(by: disposeBag)

        waitForExpectations(timeout: 0.05)
    }
    
}
