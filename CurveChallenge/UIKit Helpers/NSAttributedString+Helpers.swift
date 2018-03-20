//
//  NSAttributedString+Helpers.swift
//  CurveChallenge
//
//  Created by Sam Watts on 20/03/2018.
//  Copyright © 2018 Sam Watts. All rights reserved.
//

import UIKit

extension NSAttributedString {

    convenience init(rating: Double) {
        let color: UIColor
        switch rating {
        case 7...:
            color = .highRating
        case 4..<7:
            color = .mediumRating
        default:
            color = .lowRating
        }

        let attributedString = NSMutableAttributedString()
        attributedString.append(NSAttributedString(string: Int(rating * 10).description, attributes: [.foregroundColor: color, .font: UIFont.rating]))
        attributedString.append(NSAttributedString(string: "%", attributes: [.foregroundColor: color, .font: UIFont.ratingPercentage]))

        self.init(attributedString: attributedString)
    }
}
