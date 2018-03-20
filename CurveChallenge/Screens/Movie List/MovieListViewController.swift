//
//  MovieListViewController.swift
//  CurveChallenge
//
//  Created by Sam Watts on 20/03/2018.
//  Copyright © 2018 Sam Watts. All rights reserved.
//

import UIKit
import Kingfisher
import RxSwift
import RxCocoa

extension NSAttributedString {

    convenience init(rating: Double) {
        let color: UIColor
        switch rating {
        case 7...:
            color = .highRating
        case 4..<7:
            color = .mediumRating
        default:
            color = .lowRating
        }

        let formattedRating = String(format: "%i%%", Int(rating * 10))
        self.init(string: formattedRating, attributes: [.foregroundColor: color])
    }
}

final class MovieListViewController: BaseViewController {

    private let viewModel: MovieListViewModel
    weak private var coordinationDelegate: MovieListViewControllerCoordinationDelegate?

    init(viewModel: MovieListViewModel, coordinationDelegate: MovieListViewControllerCoordinationDelegate) {
        self.viewModel = viewModel
        self.coordinationDelegate = coordinationDelegate
        super.init()
    }

    let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.registerReusableCell(MovieTableViewCell.self)
        tableView.rowHeight = 200
        tableView.backgroundColor = .background
        return tableView
    }()

    let loadMoreFooterView = LoadMoreFooterView()

    override func loadView() {
        self.view = tableView
        tableView.tableFooterView = loadMoreFooterView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupBindings()
    }

    private func setupBindings() {

        viewModel
            .titleLocalizedStringKey.asObservable()
            .map { NSLocalizedString($0, comment: "") }
            .bind(to: self.navigationItem.rx.title)
            .disposed(by: disposeBag)

        viewModel
            .movies.asObservable()
            .bind(to: tableView.rx.items(cellIdentifier: MovieTableViewCell.reuseIdentifier)) { [unowned self] (_, movie: Movie, cell: MovieTableViewCell) in
                let viewState = MovieTableViewCell.ViewState(
                    imageURL: URL.poster(withPath: movie.posterPath),
                    name: movie.originalTitle,
                    date: movie.releaseDate.description,
                    favourited: self.viewModel.isMovieFavourited(movie),
                    overview: movie.overview,
                    rating: NSAttributedString(rating: movie.voteAverage)
                )
                cell.viewState = viewState

                //add binding for buttons
                cell.favouriteButton.rx.tap.subscribe(onNext: {
                    self.viewModel.toggleFavourite(forMovie: movie)
                }).disposed(by: cell.disposeBag)
            }
            .disposed(by: disposeBag)

        tableView.rx
            .itemSelected
            .map { [unowned self] indexPath -> (Movie, IndexPath) in
                return (self.viewModel.movies.value[indexPath.row], indexPath) //include index path and model item
            }.subscribe(onNext: { movie, indexPath in
                self.coordinationDelegate?.didSelect(movie: movie, atIndexPath: indexPath)
            })
            .disposed(by: disposeBag)

        loadMoreFooterView
            .loadMoreButton.rx
            .tap
            .subscribe(onNext: { [unowned self] in
                self.viewModel.fetchNextPage()
            })
            .disposed(by: disposeBag)

        viewModel
            .canLoadMorePages
            .map { !$0 } //negate so we hide button when no pages can be loaded
            .observeOn(MainScheduler.instance)
            .bind(to: loadMoreFooterView.rx.isHidden) //this isnt the best solution but its a good quick one (there is still an issue with table offset when the footer is removed)
            .disposed(by: disposeBag)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        viewModel.fetchNextPage()
    }
}
