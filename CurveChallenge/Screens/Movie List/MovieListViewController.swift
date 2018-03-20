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

//this is an abstraction around URLSession which will help testing view models
protocol DataProvider {
    func fetchData(fromURL url: URL) -> Observable<Data>
}

//URLSession is the easiest way, build on existing Rx extensions to add conformance
extension URLSession: DataProvider {

    func fetchData(fromURL url: URL) -> Observable<Data> {
        return self.rx.data(request: URLRequest(url: url))
    }
}

final class MovieListViewModel {

    let disposeBag = DisposeBag()

    let dataProvider: DataProvider

    let movies: BehaviorRelay<[Movie]> = BehaviorRelay(value: [])
    let titleLocalizedStringKey: BehaviorRelay<String> = BehaviorRelay(value: "popular_movie_list_title")

    init(dataProvider: DataProvider = URLSession.shared) {
        self.dataProvider = dataProvider
    }

    func fetchCreditScore() {

        dataProvider
            .fetchData(fromURL: .popularMovies(forPage: 1))
            .subscribe()
            .disposed(by: disposeBag)
//            .convertToCreditReportInfo()
//            .wrapInState() //convert to a state type so we can bind to the credit report relay
//            .observeOn(MainScheduler.instance) //UI triggers are based off of the creditReport relay so move back to main thread here
//            .bind(to: creditReport)
//            .disposed(by: disposeBag)
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

        tableView.dataSource = self
        tableView.delegate = self
    }
}

extension MovieListViewController: UITableViewDataSource, UITableViewDelegate {

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

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        coordinationDelegate?.didSelect(movie: "test", atIndexPath: indexPath)
    }
}
