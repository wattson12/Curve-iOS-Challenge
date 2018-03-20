//
//  Reusable.swift
//  CurveChallenge
//
//  Created by Sam Watts on 20/03/2018.
//  Copyright © 2018 Sam Watts. All rights reserved.
//

import UIKit

//Protocol to simplify registering table view cells
protocol Reusable {
    static var reuseIdentifier: String { get }
}

//provide a default implementation for all table view cells
extension UITableViewCell: Reusable {

    static var reuseIdentifier: String {
        return String(describing: self)
    }
}

//and some helpers for registering (dequeue not required since rx handles that)
extension UITableView {

    func registerReusableCell<Cell: UITableViewCell>(_ cellType: Cell.Type) {
        self.register(cellType, forCellReuseIdentifier: cellType.reuseIdentifier)
    }
}
