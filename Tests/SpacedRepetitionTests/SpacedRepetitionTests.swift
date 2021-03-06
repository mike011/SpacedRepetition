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
        XCTAssertEqual(sut.fibonacci(0), 1)
        XCTAssertEqual(sut.fibonacci(1), 2)
        XCTAssertEqual(sut.fibonacci(2), 3)
        XCTAssertEqual(sut.fibonacci(3), 4)
        XCTAssertEqual(sut.fibonacci(4), 5)
        XCTAssertEqual(sut.fibonacci(5), 8)
        XCTAssertEqual(sut.fibonacci(6), 13)
        XCTAssertEqual(sut.fibonacci(8), 34)
        XCTAssertEqual(sut.fibonacci(15), 987)
        XCTAssertEqual(sut.fibonacci(16), 987)
    }

    func testGetFibonacciIndex() {
        let sut = SpacedRepetition(currentIncrementAmount: 0)
        XCTAssertEqual(sut.getFibonacciIndex(0), 0)
        XCTAssertEqual(sut.getFibonacciIndex(1), 1)
        XCTAssertEqual(sut.getFibonacciIndex(2), 2)
        XCTAssertEqual(sut.getFibonacciIndex(3), 3)
        XCTAssertEqual(sut.getFibonacciIndex(4), 4)
        XCTAssertEqual(sut.getFibonacciIndex(5), 5)
        XCTAssertEqual(sut.getFibonacciIndex(8), 6)
    }
}
