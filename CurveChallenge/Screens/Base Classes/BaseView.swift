//
//  BaseView.swift
//  CurveChallenge
//
//  Created by Sam Watts on 20/03/2018.
//  Copyright © 2018 Sam Watts. All rights reserved.
//

import UIKit

class BaseView: UIView {

    @available(iOS, unavailable, message: "init(coder:) is unavailable, use init() instead")
    required init?(coder aDecoder: NSCoder) { fatalError() }

    @available(iOS, unavailable, message: "init(frame:) is unavailable, use init() instead")
    override init(frame: CGRect) { fatalError() }

    init() {
        super.init(frame: .zero)
    }
}
