//
//  MoviesAppUITests.swift
//  MovieAppUITests
//
//  Created by Jigar Oza on 21/02/25.
//

import XCTest

final class MoviesAppUITests: XCTestCase {
    var app: XCUIApplication!

    override func setUp() {
        super.setUp()
        app = XCUIApplication()
        app.launch()
        continueAfterFailure = false
    }

    override func tearDown() {
        app = nil
        super.tearDown()
    }

    func testSearchMovies() {
        let searchBar = app.searchFields["Search"]
        XCTAssertTrue(searchBar.exists, "Search bar should be present")
        
        searchBar.tap()
        searchBar.typeText("Inception")
        app.keyboards.buttons["Search"].tap()
        
        let firstCell = app.tables.cells.firstMatch
        let exists = firstCell.waitForExistence(timeout: 5)
        
        XCTAssertTrue(exists, "Movies should appear in the list")
    }
    
    func testEmptySearchShowsNoResults() {
        let searchBar = app.searchFields["Search"]
        searchBar.tap()
        searchBar.typeText("qwertyuiop")
        app.buttons["Search"].firstMatch.tap()
        
        let tableView = app.tables.firstMatch
        XCTAssertEqual(tableView.cells.count, 0, "Table should be empty for no results")
    }
    
    func testTableViewCellSelection() {
        let searchBar = app.searchFields["Search"]
        XCTAssertTrue(searchBar.exists, "Search bar should be present")
        
        searchBar.tap()
        searchBar.typeText("Inception")
        app.keyboards.buttons["Search"].tap()

        let firstCell = app.tables.cells.element(boundBy: 0)

        XCTAssertTrue(firstCell.waitForExistence(timeout: 5), "The first cell should exist")

        firstCell.tap()

        XCTAssertFalse(firstCell.isSelected, "Cell should be deselected after tapping")
    }
}
