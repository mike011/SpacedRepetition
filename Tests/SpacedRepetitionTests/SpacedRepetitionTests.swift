//
//  SpacedRepetitionTests.swift
//  SpacedRepetitionTests
//
//  Created by Michael Charland on 2019-03-14.
//  Copyright © 2019 charland. All rights reserved.
//

import XCTest
@testable import SpacedRepetition

class SpacedRepetitionTests: XCTestCase {

    func testWrongAnswer() {
        let sut = SpacedRepetition(currentIncrementAmount: 5)
        let date = sut.handleWrongAnswer()
        XCTAssertEqual(date, 0)
    }

    func testRightAnswerNeverAnsweredQuestionBefore() {
        let sut = SpacedRepetition(currentIncrementAmount: 0)
        let date = sut.handleRightAnswer()
        XCTAssertEqual(date, 1)
    }

    func testRightAnswerOneDay() {
        let sut = SpacedRepetition(currentIncrementAmount: 1)
        XCTAssertEqual(sut.handleRightAnswer(), 2)
        XCTAssertEqual(sut.handleRightAnswer(), 3)
        XCTAssertEqual(sut.handleRightAnswer(), 4)
        XCTAssertEqual(sut.handleRightAnswer(), 5)
        XCTAssertEqual(sut.handleRightAnswer(), 8)
    }

    func testFibonacci() {
        let sut = SpacedRepetition(currentIncrementAmount: 1)
        XCTAssertEqual(sut.getFibonacciValue(atIndex: 0), 1)
        XCTAssertEqual(sut.getFibonacciValue(atIndex: 1), 2)
        XCTAssertEqual(sut.getFibonacciValue(atIndex: 2), 3)
        XCTAssertEqual(sut.getFibonacciValue(atIndex: 3), 4)
        XCTAssertEqual(sut.getFibonacciValue(atIndex: 4), 5)
        XCTAssertEqual(sut.getFibonacciValue(atIndex: 5), 8)
        XCTAssertEqual(sut.getFibonacciValue(atIndex: 6), 13)
        XCTAssertEqual(sut.getFibonacciValue(atIndex: 8), 34)
        XCTAssertEqual(sut.getFibonacciValue(atIndex: 15), 987)
        XCTAssertEqual(sut.getFibonacciValue(atIndex: 16), 987)
    }

    func testGetFibonacciIndex() {
        let sut = SpacedRepetition(currentIncrementAmount: 0)
        XCTAssertEqual(sut.getNextFibonacciIndex(fromValue: 0), 0)
        XCTAssertEqual(sut.getNextFibonacciIndex(fromValue: 1), 1)
        XCTAssertEqual(sut.getNextFibonacciIndex(fromValue: 2), 2)
        XCTAssertEqual(sut.getNextFibonacciIndex(fromValue: 3), 3)
        XCTAssertEqual(sut.getNextFibonacciIndex(fromValue: 4), 4)
        XCTAssertEqual(sut.getNextFibonacciIndex(fromValue: 5), 5)
        XCTAssertEqual(sut.getNextFibonacciIndex(fromValue: 8), 6)
    }
}
