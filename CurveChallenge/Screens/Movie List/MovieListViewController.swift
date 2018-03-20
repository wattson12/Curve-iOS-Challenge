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

extension MovieTableViewCell.ViewState {

    init(movie: Movie, isFavourited: Bool) {
        self.init(
            imageURL: URL.poster(withPath: movie.posterPath),
            name: movie.originalTitle,
            date: DateFormatter.releaseDateDisplay.string(from: movie.releaseDate),
            favourited: isFavourited,
            overview: movie.overview,
            rating: NSAttributedString(rating: movie.voteAverage)
        )
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
        tableView.separatorStyle = .none
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

        //bind title to navigation item (via localisation)
        viewModel
            .titleLocalizedStringKey.asObservable()
            .map { NSLocalizedString($0, comment: "") }
            .bind(to: self.navigationItem.rx.title)
            .disposed(by: disposeBag)

        //setup data source for table view and configure cells
        viewModel
            .movies.asObservable()
            .bind(to: tableView.rx.items(cellIdentifier: MovieTableViewCell.reuseIdentifier)) { [unowned self] (_, movie: Movie, cell: MovieTableViewCell) in
                cell.viewState = MovieTableViewCell.ViewState(movie: movie, isFavourited: self.viewModel.isMovieFavourited(movie))

                //add binding for buttons
                cell.favouriteButton.rx.tap.subscribe(onNext: {
                    self.viewModel.toggleFavourite(forMovie: movie)
                }).disposed(by: cell.disposeBag)
            }
            .disposed(by: disposeBag)

        //listen for cell selection
        tableView.rx
            .itemSelected
            .map { [unowned self] indexPath -> (Movie, IndexPath) in
                return (self.viewModel.movies.value[indexPath.row], indexPath) //include index path and model item
            }.subscribe(onNext: { movie, indexPath in
                self.coordinationDelegate?.didSelect(movie: movie, atIndexPath: indexPath)
            })
            .disposed(by: disposeBag)

        //fetch next page when load more button is tapped
        loadMoreFooterView
            .loadMoreButton.rx
            .tap
            .subscribe(onNext: { [unowned self] in
                self.viewModel.fetchNextPage()
            })
            .disposed(by: disposeBag)

        //hide load more button when there are no more pages to fetch
        viewModel
            .canLoadMorePages
            .map { !$0 } //negate so we hide button when no pages can be loaded
            .observeOn(MainScheduler.instance)
            .bind(to: loadMoreFooterView.rx.isHidden) //this isnt the best solution but its a good quick one (there is still an issue with table offset when the footer is removed)
            .disposed(by: disposeBag)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        //fetch the first page on first load
        viewModel.fetchNextPage()
    }
}
