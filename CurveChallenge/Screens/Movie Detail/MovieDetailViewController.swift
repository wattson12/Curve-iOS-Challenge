//
//  MovieDetailViewController.swift
//  CurveChallenge
//
//  Created by Sam Watts on 20/03/2018.
//  Copyright © 2018 Sam Watts. All rights reserved.
//

import UIKit
import Kingfisher
import RxSwift
import RxCocoa

final class MovieDetailViewController: BaseViewController {

    let backgroundView: UIView = {
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor(red: 0.255, green: 0.255, blue: 0.255, alpha: 1)
        return backgroundView
    }()

    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.layer.borderWidth = 5
        imageView.accessibilityIdentifier = "full_size_poster_view"
        return imageView
    }()

    private let viewModel: MovieDetailViewModel

    init(viewModel: MovieDetailViewModel) {
        self.viewModel = viewModel
        super.init()
    }

    override func loadView() {
        self.view = backgroundView

        self.view.addSubview(imageView)

        //keep centered within view, while preserving aspect ratio
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: backgroundView.safeAreaLayoutGuide.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: backgroundView.safeAreaLayoutGuide.centerYAnchor),

            imageView.topAnchor.constraint(greaterThanOrEqualTo: backgroundView.safeAreaLayoutGuide.topAnchor, constant: 10),
            imageView.trailingAnchor.constraint(lessThanOrEqualTo: backgroundView.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            imageView.bottomAnchor.constraint(lessThanOrEqualTo: backgroundView.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            imageView.leadingAnchor.constraint(greaterThanOrEqualTo: backgroundView.safeAreaLayoutGuide.leadingAnchor, constant: 10),

            imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor, multiplier: 2 / 3).withPriority(.required)
        ])
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupBindings()
    }

    private func setupBindings() {

        viewModel
            .movie.asObservable()
            .map { $0.originalTitle }
            .bind(to: self.navigationItem.rx.title)
            .disposed(by: disposeBag)

        viewModel
            .movie.asObservable()
            .map { URL.poster(withPath: $0.posterPath) }
            .subscribe(onNext: { [unowned self] posterURL in
                self.imageView.kf.setImage(with: posterURL)
            })
            .disposed(by: disposeBag)
    }
}
