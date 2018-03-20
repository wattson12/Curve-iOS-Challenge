//
//  MovieTableViewCell.swift
//  CurveChallenge
//
//  Created by Sam Watts on 20/03/2018.
//  Copyright © 2018 Sam Watts. All rights reserved.
//

import UIKit
import RxSwift

final class MovieTableViewCell: UITableViewCell {

    private(set) var disposeBag: DisposeBag = DisposeBag()

    struct ViewState {
        let imageURL: URL?
        let name: String
        let date: String
        let favourited: Bool
        let overview: String
        let rating: NSAttributedString
    }

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    let movieImageView: UIImageView = {
        let movieImageView = UIImageView()
        movieImageView.translatesAutoresizingMaskIntoConstraints = false
        return movieImageView
    }()

    let nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        return nameLabel
    }()

    let dateLabel: UILabel = {
        let dateLabel = UILabel()
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        return dateLabel
    }()

    let favouriteButton: UIButton = {
        let favouriteButton = UIButton()
        favouriteButton.translatesAutoresizingMaskIntoConstraints = false
        return favouriteButton
    }()

    let overviewLabel: UILabel = {
        let overviewLabel = UILabel()
        overviewLabel.numberOfLines = 0
        overviewLabel.translatesAutoresizingMaskIntoConstraints = false
        overviewLabel.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        return overviewLabel
    }()

    let ratingLabel: UILabel = {
        let ratingLabel = UILabel()
        ratingLabel.translatesAutoresizingMaskIntoConstraints = false
        ratingLabel.setContentCompressionResistancePriority(.required, for: .vertical)
        return ratingLabel
    }()

    private func commonInit() {
        self.translatesAutoresizingMaskIntoConstraints = false

        self.contentView.addSubview(movieImageView)
        self.contentView.addSubview(nameLabel)
        self.contentView.addSubview(dateLabel)
        self.contentView.addSubview(favouriteButton)
        self.contentView.addSubview(overviewLabel)
        self.contentView.addSubview(ratingLabel)

        //image view is pinned to size of cell on left hand size, ratio of 2:3
        NSLayoutConstraint.activate([
            movieImageView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            movieImageView.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            movieImageView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
            movieImageView.widthAnchor.constraint(equalTo: movieImageView.heightAnchor, multiplier: 2 / 3)
            ])

        //name and date label at top left, favourites to the right
        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(equalTo: movieImageView.trailingAnchor, constant: 10),
            nameLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 10),
            nameLabel.trailingAnchor.constraint(lessThanOrEqualTo: favouriteButton.leadingAnchor, constant: -10),
            dateLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            dateLabel.topAnchor.constraint(equalTo: nameLabel.lastBaselineAnchor, constant: 5),
            dateLabel.trailingAnchor.constraint(lessThanOrEqualTo: favouriteButton.leadingAnchor, constant: -10),
            favouriteButton.topAnchor.constraint(equalTo: nameLabel.topAnchor),
            favouriteButton.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -10),
            favouriteButton.widthAnchor.constraint(equalToConstant: 44),
            favouriteButton.heightAnchor.constraint(equalToConstant: 44)
            ])

        //overview below those, but above rating
        NSLayoutConstraint.activate([
            overviewLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            overviewLabel.trailingAnchor.constraint(lessThanOrEqualTo: self.contentView.trailingAnchor, constant: -10),
            overviewLabel.topAnchor.constraint(greaterThanOrEqualTo: favouriteButton.bottomAnchor, constant: 10),
            overviewLabel.bottomAnchor.constraint(lessThanOrEqualTo: ratingLabel.topAnchor, constant: -10).withPriority(.required)
            ])

        //rating at the bottom right
        NSLayoutConstraint.activate([
            ratingLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -10),
            ratingLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -10)
            ])
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        viewState = nil
        disposeBag = DisposeBag() //reset this to clear any observers
    }

    var viewState: ViewState? {
        didSet {
            guard let viewState = viewState else {
                reset()
                return
            }

            updateContents(withViewState: viewState)
        }
    }

    private func reset() {
        movieImageView.kf.setImage(with: nil)
        nameLabel.text = nil
        dateLabel.text = nil
        favouriteButton.backgroundColor = .red
        overviewLabel.text = nil
        ratingLabel.attributedText = nil
    }

    private func updateContents(withViewState viewState: ViewState) {
        movieImageView.kf.setImage(with: viewState.imageURL)
        nameLabel.text = viewState.name
        dateLabel.text = viewState.date
        favouriteButton.backgroundColor = viewState.favourited ? .green : .red
        overviewLabel.text = viewState.overview
        ratingLabel.attributedText = viewState.rating
    }
}
