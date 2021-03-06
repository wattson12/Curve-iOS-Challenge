//
//  AppCoordinator.swift
//  CurveChallenge
//
//  Created by Sam Watts on 20/03/2018.
//  Copyright © 2018 Sam Watts. All rights reserved.
//

import UIKit

final class AppCoordinator {

    private let window: UIWindow

    //helper to fetch the root view controller for navigation
    private var navigationController: UINavigationController? {
        return window.rootViewController as? UINavigationController
    }

    init(withWindow window: UIWindow) {
        self.window = window
    }

    func start() {
        let rootViewController = MovieListViewController(viewModel: MovieListViewModel(), coordinationDelegate: self)
        let rootNavigationController = UINavigationController(rootViewController: rootViewController)

        window.rootViewController = rootNavigationController
        window.backgroundColor = .white

        window.makeKeyAndVisible()
    }
}

protocol MovieListViewControllerCoordinationDelegate: class {
    func didSelect(movie: Movie, atIndexPath indexPath: IndexPath)
}

extension AppCoordinator: MovieListViewControllerCoordinationDelegate {

    func didSelect(movie: Movie, atIndexPath indexPath: IndexPath) {
        let movieDetailViewController = MovieDetailViewController(viewModel: MovieDetailViewModel(movie: movie))
        navigationController?.pushViewController(movieDetailViewController, animated: true)
    }
}
