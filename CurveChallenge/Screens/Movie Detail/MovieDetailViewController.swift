//
//  MovieDetailViewController.swift
//  CurveChallenge
//
//  Created by Sam Watts on 20/03/2018.
//  Copyright © 2018 Sam Watts. All rights reserved.
//

import UIKit
import Kingfisher

class MovieDetailViewController: BaseViewController {

    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    override func loadView() {
        self.view = UIView()

        self.view.addSubview(imageView)

        //pinned to within bounds of view
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 10),
            imageView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            imageView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            imageView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 10)
        ])
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        imageView.kf.setImage(with: URL(string: "https://image.tmdb.org/t/p/w500//sM33SANp9z6rXW8Itn7NnG1GOEs.jpg"))
    }
}
