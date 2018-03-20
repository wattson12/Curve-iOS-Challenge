//
//  LoadMoreFooterView.swift
//  CurveChallenge
//
//  Created by Sam Watts on 20/03/2018.
//  Copyright © 2018 Sam Watts. All rights reserved.
//

import UIKit

final class LoadMoreFooterView: BaseView {

    let loadMoreButton: UIButton = {
        let loadMoreButton = UIButton()
        loadMoreButton.setTitle(NSLocalizedString("load_more_button_title", comment: ""), for: .normal)
        loadMoreButton.setTitleColor(.white, for: .normal)
        return loadMoreButton
    }()

    override init() {
        super.init()
        self.frame = CGRect(x: 0, y: 0, width: 0, height: 60)

        self.backgroundColor = .background

        self.addSubview(loadMoreButton)
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        //layout out here because table view footers can sometimes misbehave when you mix auto layout and springs / struts
        loadMoreButton.sizeToFit()
        loadMoreButton.center = CGPoint(x: self.bounds.midX, y: self.bounds.midY)
    }
}
