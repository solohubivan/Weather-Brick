//
//  Weather_BrickUITests.swift
//  Weather BrickUITests
//
//  Created by Ivan Solohub on 13.09.2023.
//

import XCTest

final class Weather_BrickUITests: XCTestCase {
    
    var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }

    override func tearDownWithError() throws {
        app = nil
        super.tearDown()
    }

    func testTitleLabelText() throws {
        app.buttons["INFO"].tap()
        
        let titleLabel = app.staticTexts["infoTitleLabel"]
        let expectedText = "INFO"
        
        XCTAssertEqual(titleLabel.label, expectedText)
    }
    
    func testStackViewText() throws {
        app.buttons["INFO"].tap()

        let stackView = app.scrollViews.otherElements["infoLabelsStackView"]
        let expectedTexts = [
            "Brick is wet - raining",
            "Brick is dry - sunny",
            "Brick is hard to see - fog",
            "Brick with cracks - very hot",
            "Brick with snow - snow",
            "Brick is swinging - windy",
            "Brick is gone - no internet"
        ]

        for (index, element) in stackView.children(matching: .staticText).allElementsBoundByIndex.enumerated() {
            let labelText = element.label
            
            XCTAssertEqual(labelText, expectedTexts[index])
        }
    }
    
    func testReturnToMainVCButtonText() throws {
        app.buttons["INFO"].tap()
        
        let button = app.buttons["returnMainVCButton"]
        
        XCTAssertEqual(button.label, "Hide")
    }
    
    func testReturnToMainVC() throws {
        app.buttons["INFO"].tap()
        sleep(2)
        app.buttons["returnMainVCButton"].tap()
        XCTAssertTrue(app.buttons["INFO"].exists)
    }
}
