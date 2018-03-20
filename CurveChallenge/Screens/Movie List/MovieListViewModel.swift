//
//  MovieListViewModel.swift
//  CurveChallenge
//
//  Created by Sam Watts on 20/03/2018.
//  Copyright © 2018 Sam Watts. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

final class MovieListViewModel {

    let disposeBag = DisposeBag()

    let dataProvider: DataProvider

    let movies: BehaviorRelay<[Movie]> = BehaviorRelay(value: [])
    let titleLocalizedStringKey: BehaviorRelay<String> = BehaviorRelay(value: "popular_movie_list_title")

    init(dataProvider: DataProvider = URLSession.shared) {
        self.dataProvider = dataProvider
    }

    func fetchNextPage() {

        dataProvider
            .fetchData(fromURL: .popularMovies(forPage: 1))
            .convert(to: APIResult<Movie>.self)
            .observeOn(MainScheduler.instance) //UI triggers are based off of the creditReport relay so move back to main thread here
            .subscribe(onNext: { [unowned self] result in
                let allMovies = self.movies.value + result.results
                self.movies.accept(allMovies)
            })
            .disposed(by: disposeBag)
    }
}
