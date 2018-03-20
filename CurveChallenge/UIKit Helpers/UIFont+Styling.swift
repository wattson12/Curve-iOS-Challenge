//
//  UIFont+Styling.swift
//  CurveChallenge
//
//  Created by Sam Watts on 20/03/2018.
//  Copyright © 2018 Sam Watts. All rights reserved.
//

import UIKit

extension UIFont {

    static var movieTitle: UIFont {
        return UIFont.boldSystemFont(ofSize: 16)
    }

    static var date: UIFont {
        return UIFont.italicSystemFont(ofSize: 12)
    }

    static var overview: UIFont {
        return UIFont.systemFont(ofSize: 12)
    }

    static var rating: UIFont {
        return UIFont.systemFont(ofSize: 20)
    }

    static var ratingPercentage: UIFont {
        return UIFont.systemFont(ofSize: 12)
    }
}
