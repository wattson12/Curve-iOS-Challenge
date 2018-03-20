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

extension UIColor { //TODO: remove

    class var random: UIColor {

        let hue = ( Double(Double(arc4random()).truncatingRemainder(dividingBy: 256.0) ) / 256.0 )
        let saturation = ( (Double(arc4random()).truncatingRemainder(dividingBy: 128)) / 256.0 ) + 0.5
        let brightness = ( (Double(arc4random()).truncatingRemainder(dividingBy: 128)) / 256.0 ) + 0.5

        return UIColor(hue: CGFloat(hue), saturation: CGFloat(saturation), brightness: CGFloat(brightness), alpha: 1.0)
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
        return tableView
    }()

    override func loadView() {
        self.view = tableView
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
            .bind(to: tableView.rx.items(cellIdentifier: MovieTableViewCell.reuseIdentifier)) { (_, movie: Movie, cell: MovieTableViewCell) in
                let viewState = MovieTableViewCell.ViewState(
                    imageURL: URL.poster(withPath: movie.posterPath),
                    name: movie.originalTitle,
                    date: movie.releaseDate.description,
                    favourited: false,
                    overview: movie.overview,
                    rating: NSAttributedString(string: movie.voteAverage.description, attributes: [.foregroundColor: UIColor.red])
                )
                cell.viewState = viewState
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
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        viewModel.fetchNextPage()
    }
}
