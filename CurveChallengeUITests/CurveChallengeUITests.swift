//
//  CurveChallengeUITests.swift
//  CurveChallengeUITests
//
//  Created by Sam Watts on 20/03/2018.
//  Copyright © 2018 Sam Watts. All rights reserved.
//

import XCTest

class CurveChallengeUITests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    //this is not a good test since it uses the real network, but I didnt have time to implement test based network stubbing
    func testNavigation() {
        let app = XCUIApplication()

        XCTAssertTrue(app.staticTexts["Zootopia"].waitForExistence(timeout: 2))
        app.staticTexts["Zootopia"].tap()

        XCTAssertTrue(app.images["full_size_poster_view"].waitForExistence(timeout: 1))
    }
    
}
