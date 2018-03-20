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

    init(withWindow window: UIWindow) {
        self.window = window
    }

    func start() {
        let rootViewController = MovieListViewController()
        let rootNavigationController = UINavigationController(rootViewController: rootViewController)

        window.rootViewController = rootNavigationController
        window.backgroundColor = .white

        window.makeKeyAndVisible()
    }
}
