//
//  BaseViewController.swift
//  CurveChallenge
//
//  Created by Sam Watts on 20/03/2018.
//  Copyright © 2018 Sam Watts. All rights reserved.
//

import UIKit
import RxSwift

class BaseViewController: UIViewController {

    //Add dispose bag here since most view controllers will use one
    let disposeBag = DisposeBag()

    //Marking default initialisers as unavable while not needed
    //This saves base classes needing to provide them, and coordinators using them incorrectly
    @available(iOS, unavailable, message: "init(nibName:bundle:) is unavailable, use init() or class specific init instead")
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) { fatalError() }

    @available(iOS, unavailable, message: "init(coder:) is unavailable, use init() or class specific init instead")
    required init?(coder aDecoder: NSCoder) { fatalError() }

    init() {
        super.init(nibName: nil, bundle: nil)
    }
}
