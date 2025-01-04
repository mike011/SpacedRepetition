//
//  DateExtensionTests.swift
//  
//
//  Created by Michael Charland on 2021-03-20.
//

import Foundation

import Testing
@testable import SpacedRepetition

@Suite struct DateExtensionTests {

    // MARK: - isAfterToday

    @Test func isAfterTodayToday() {
        #expect(!Date().isAfterToday())
    }

    @Test func isAfterTodayTomorrow() {
        let date = Date(timeIntervalSinceNow: 87000)
        #expect(date.isAfterToday())
    }

    @Test func isAfterTodayYesterday() {
        let date = Date(timeIntervalSinceNow: -87000)
        #expect(!date.isAfterToday())
    }

    @Test func isAfterTodayWayInTheFuture() {
        let date = Date(timeIntervalSinceNow: 8700000)
        #expect(date.isAfterToday())
    }
}
