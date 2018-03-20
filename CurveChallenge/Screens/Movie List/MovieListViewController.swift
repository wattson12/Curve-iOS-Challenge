//
//  MovieListViewController.swift
//  CurveChallenge
//
//  Created by Sam Watts on 20/03/2018.
//  Copyright © 2018 Sam Watts. All rights reserved.
//

import UIKit
import Kingfisher

extension UIColor { //TODO: remove

    class var random: UIColor {

        let hue = ( Double(Double(arc4random()).truncatingRemainder(dividingBy: 256.0) ) / 256.0 )
        let saturation = ( (Double(arc4random()).truncatingRemainder(dividingBy: 128)) / 256.0 ) + 0.5
        let brightness = ( (Double(arc4random()).truncatingRemainder(dividingBy: 128)) / 256.0 ) + 0.5

        return UIColor(hue: CGFloat(hue), saturation: CGFloat(saturation), brightness: CGFloat(brightness), alpha: 1.0)
    }
}

extension UIView { //TODO: remove
    func mark(withColor color: UIColor = .random) {
        self.layer.borderColor = color.cgColor
        self.layer.borderWidth = 1.0
    }
}

//TODO: move this
protocol Reusable {
    static var reuseIdentifier: String { get }
}

extension UITableViewCell: Reusable {

    static var reuseIdentifier: String {
        return String(describing: self)
    }
}

extension UITableView {

    func registerReusableCell<Cell: UITableViewCell>(_ cellType: Cell.Type) {
        self.register(cellType, forCellReuseIdentifier: cellType.reuseIdentifier)
    }

    func dequeueReusableCell<Cell: UITableViewCell>(_ cellType: Cell.Type, forIndexPath indexPath: IndexPath) -> Cell {
        guard let cell = self.dequeueReusableCell(withIdentifier: cellType.reuseIdentifier, for: indexPath) as? Cell else {
            fatalError("Unable to dequeue cell of type \(cellType) for indexPath: \(indexPath)")
        }

        return cell
    }
}

final class MovieTableViewCell: UITableViewCell {

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
        return overviewLabel
    }()

    let ratingLabel: UILabel = {
        let ratingLabel = UILabel()
        ratingLabel.translatesAutoresizingMaskIntoConstraints = false
        return ratingLabel
    }()

    private func commonInit() {
        self.translatesAutoresizingMaskIntoConstraints = false

        self.contentView.addSubview(movieImageView)
        self.contentView.addSubview(nameLabel)
        self.contentView.addSubview(dateLabel)
        self.contentView.addSubview(favouriteButton)
        self.contentView.addSubview(overviewLabel)
        //        self.contentView.addSubview(ratingLabel) //TODO: restore this

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
            overviewLabel.bottomAnchor.constraint(lessThanOrEqualTo: self.contentView.bottomAnchor, constant: -10)
        ])

        //rating at the bottom right
//        NSLayoutConstraint.activate([
//            ratingLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -10),
//            ratingLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -10)
//        ])
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        viewState = nil
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

final class MovieListViewController: BaseViewController {

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

        tableView.dataSource = self
    }
}

extension MovieListViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(MovieTableViewCell.self, forIndexPath: indexPath)

        let viewState = MovieTableViewCell.ViewState(
            imageURL: URL(string: "https://image.tmdb.org/t/p/w500//sM33SANp9z6rXW8Itn7NnG1GOEs.jpg"),
            name: "Zootopia",
            date: "2016-02-11",
            favourited: true,
            overview: "Determined to prove herself, Officer Judy Hopps, the first bunny on Zootopia's police force, jumps at the chance to crack her first case - even if it means partnering with scam-artist fox Nick Wilde to solve the mystery.",
            rating: NSAttributedString(string: "77%", attributes: [.foregroundColor: UIColor.red])
        )

        cell.viewState = viewState

        return cell
    }
}
