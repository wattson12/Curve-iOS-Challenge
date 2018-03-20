//
//  MovieListViewModelTests.swift
//  CurveChallengeTests
//
//  Created by Sam Watts on 20/03/2018.
//  Copyright © 2018 Sam Watts. All rights reserved.
//

import XCTest
@testable import CurveChallenge
import RxSwift
import RxCocoa

struct StubDataProvider: DataProvider {

    let stubbedData: Data?
    let stubbedError: Error?

    func fetchData(fromURL url: URL) -> Observable<Data> {
        return Observable.create { observer in
            if let data = self.stubbedData {
                observer.onNext(data)
                observer.onCompleted()
            } else if let error = self.stubbedError {
                observer.onError(error)
            }

            return Disposables.create()
        }
    }
}


class MovieListViewModelTests: XCTestCase {
    
    var disposeBag: DisposeBag!

    override func setUp() {
        super.setUp()

        disposeBag = DisposeBag()
    }

    func testMoviesAreMappedFromAPIResponseAndBoundToMovieObservable() {
        let dataProvider = StubDataProvider(stubbedData: testData(fromFixtureNamed: "full_response"), stubbedError: nil)
        let viewModel = MovieListViewModel(dataProvider: dataProvider)

        let moviesUpdated = expectation(description: "movies updated")

        viewModel.movies
            .skip(1) //ignore initial value
            .subscribe { event in
                switch event {
                case .next(let movies):
                    XCTAssertEqual(movies.count, 20)
                    moviesUpdated.fulfill()
                default:
                    XCTFail("Unexpected event: \(event)")
                }
            }
            .disposed(by: disposeBag)

        viewModel.fetchNextPage()

        waitForExpectations(timeout: 0.05)
    }

    func testTitleLocalisedStringKeyIsCorrect() {
        let dataProvider = StubDataProvider(stubbedData: nil, stubbedError: nil)
        let viewModel = MovieListViewModel(dataProvider: dataProvider)

        XCTAssertEqual(viewModel.titleLocalizedStringKey.value, "popular_movie_list_title")
    }
    
}
