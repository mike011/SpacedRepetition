//
//  DateExtensionTests.swift
//  
//
//  Created by Michael Charland on 2021-03-20.
//

import Foundation

import XCTest
@testable import SpacedRepetition

class DateExtensionTests: XCTestCase {

    // MARK: - isAfterToday

    func testIsAfterTodayToday() {
        XCTAssertFalse(Date().isAfterToday())
    }

    func testIsAfterTodayTomorrow() {
        let date = Date(timeIntervalSinceNow: 87000)
        XCTAssertTrue(date.isAfterToday())
    }

    func testIsAfterTodayYesterday() {
        let date = Date(timeIntervalSinceNow: -87000)
        XCTAssertFalse(date.isAfterToday())
    }

    func testIsAfterTodayWayInTheFuture() {
        let date = Date(timeIntervalSinceNow: 8700000)
        XCTAssertTrue(date.isAfterToday())
    }
}
