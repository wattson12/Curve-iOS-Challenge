//
//  MovieDetailViewModel.swift
//  CurveChallenge
//
//  Created by Sam Watts on 20/03/2018.
//  Copyright © 2018 Sam Watts. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

final class MovieDetailViewModel {

    let movie: BehaviorRelay<Movie>

    init(movie: Movie) {
        self.movie = BehaviorRelay(value: movie)
    }
}
