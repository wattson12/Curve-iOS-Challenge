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
    let favouriteStore: UserDefaults

    let titleLocalizedStringKey: BehaviorRelay<String> = BehaviorRelay(value: "popular_movie_list_title")

    let movies: BehaviorRelay<[Movie]> = BehaviorRelay(value: [])
    let canLoadMorePages: BehaviorRelay<Bool> = BehaviorRelay(value: true)

    private var currentPage = 1

    init(dataProvider: DataProvider = URLSession.shared, favouriteStore: UserDefaults = .standard) {
        self.dataProvider = dataProvider
        self.favouriteStore = favouriteStore
    }

    func fetchNextPage() {

        dataProvider
            .fetchData(fromURL: .popularMovies(forPage: currentPage))
            .convert(to: APIResult<Movie>.self)
            .observeOn(MainScheduler.instance) //UI triggers are based off of the creditReport relay so move back to main thread here
            .subscribe(onNext: { [unowned self] result in
                let allMovies = self.movies.value + result.results
                self.movies.accept(allMovies)

                self.currentPage = result.page + 1

                self.canLoadMorePages.accept(self.currentPage < result.totalPages)
            })
            .disposed(by: disposeBag)
    }

    func isMovieFavourited(_ movie: Movie) -> Bool {
        return favouriteStore.bool(forKey: movie.identifier.description)
    }

    func toggleFavourite(forMovie movie: Movie) {
        let isFavourited = favouriteStore.bool(forKey: movie.identifier.description)
        favouriteStore.set(!isFavourited, forKey: movie.identifier.description)

        //trigger a refresh by resetting the movie observable
        movies.accept(movies.value)
    }
}
