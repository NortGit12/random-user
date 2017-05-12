//
//  ControlsTests.swift
//  Random User
//
//  Created by Jeff Norton on 5/12/17.
//  Copyright © 2017 Jeff Norton. All rights reserved.
//

import XCTest
@testable import Random_User

class ControlsTests: XCTestCase {
    
    //==================================================
    // MARK: - _Properties
    //==================================================
    
    // General
    var app: XCUIApplication!
    var resetButton: XCUIElement!
    
    //==================================================
    // MARK: - Setup & Teardown
    //==================================================
        
    override func setUp() {
        super.setUp()
        
        continueAfterFailure = false
        
        // Launch the app
        app = XCUIApplication()
        app.launch()
        
        // Identify the reset button
        resetButton = app.buttons["resetButton"]
    }
    
    override func tearDown() {
        super.tearDown()
        
        resetButton.tap()
    }
    
    //==================================================
    // MARK: - Tests
    //==================================================
    
    func testQuantityLabelIncrementsWhenPlusStepperButtonTapped() {
        
        let quantityLabel = app.staticTexts["quantityLabel"]
        guard let originalQuantity = Int(quantityLabel.label) else {
            return XCTFail("Failure: Could not access the original quantity label's value.")
        }
        
        let stepperControlIncrementButton = app.buttons["Increment"]
        stepperControlIncrementButton.tap()
        stepperControlIncrementButton.tap()
        
        guard let updatedQuantity = Int(quantityLabel.label) else {
            return XCTFail("Failure: Could not access the updated quantity label's value.")
        }
        
        XCTAssert(updatedQuantity == (originalQuantity + 2), "The quantity value should have been incremented as expected.")
    }
}









