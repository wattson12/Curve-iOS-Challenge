//
//  Reusable.swift
//  CurveChallenge
//
//  Created by Sam Watts on 20/03/2018.
//  Copyright © 2018 Sam Watts. All rights reserved.
//

import UIKit

//Protocol to simplify registering and dequeuing table view cells
protocol Reusable {
    static var reuseIdentifier: String { get }
}

//provide a default implementation for all table view cells
extension UITableViewCell: Reusable {

    static var reuseIdentifier: String {
        return String(describing: self)
    }
}

//and some helpers for register + dequeue
extension UITableView {

    func registerReusableCell<Cell: UITableViewCell>(_ cellType: Cell.Type) {
        self.register(cellType, forCellReuseIdentifier: cellType.reuseIdentifier)
    }

    func dequeueReusableCell<Cell: UITableViewCell>(_ cellType: Cell.Type, forIndexPath indexPath: IndexPath) -> Cell {
        guard let cell = self.dequeueReusableCell(withIdentifier: cellType.reuseIdentifier, for: indexPath) as? Cell else {
            fatalError("Unable to dequeue cell of type \(cellType) for indexPath: \(indexPath)") //give a more meaningful error than force cast
        }

        return cell
    }
}
