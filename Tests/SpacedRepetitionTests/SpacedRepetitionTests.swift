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

    // MARK: - handleWrongAnswer
    func testWrongAnswer() {
        let sut = SpacedRepetition(currentIncrementAmount: 5)
        let date = sut.handleWrongAnswer()
        XCTAssertEqual(date, 0)
    }

    // MARK: - handleRightAnswer
    func testRightAnswerNeverAnsweredQuestionBefore() {
        let sut = SpacedRepetition(currentIncrementAmount: 0)
        let date = sut.handleRightAnswer()
        XCTAssertEqual(date, 1)
    }

    func testRightAnswerExtremlyLowConfidence() {
        let sut = SpacedRepetition(currentIncrementAmount: 1)
        XCTAssertEqual(sut.handleRightAnswer(confidence: .extremlyLow), 1)
        XCTAssertEqual(sut.handleRightAnswer(confidence: .extremlyLow), 1)
        XCTAssertEqual(sut.handleRightAnswer(confidence: .extremlyLow), 1)
        XCTAssertEqual(sut.handleRightAnswer(confidence: .extremlyLow), 1)
        XCTAssertEqual(sut.handleRightAnswer(confidence: .extremlyLow), 1)
    }

    func testRightAnswerLowConfidence() {
        let sut = SpacedRepetition(currentIncrementAmount: 1)
        XCTAssertEqual(sut.handleRightAnswer(confidence: .low), 2)
        XCTAssertEqual(sut.handleRightAnswer(confidence: .low), 3)
        XCTAssertEqual(sut.handleRightAnswer(confidence: .low), 4)
        XCTAssertEqual(sut.handleRightAnswer(confidence: .low), 5)
        XCTAssertEqual(sut.handleRightAnswer(confidence: .low), 6)
    }

    func testRightAnswerMediumConfidence() {
        let sut = SpacedRepetition(currentIncrementAmount: 1)
        XCTAssertEqual(sut.handleRightAnswer(confidence: .medium), 2)
        XCTAssertEqual(sut.handleRightAnswer(confidence: .medium), 3)
        XCTAssertEqual(sut.handleRightAnswer(confidence: .medium), 4)
        XCTAssertEqual(sut.handleRightAnswer(confidence: .medium), 5)
        XCTAssertEqual(sut.handleRightAnswer(confidence: .medium), 8)
    }

    // MARK: - getFibonacciValue
    func testGetFibonacciValue() {
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
        XCTAssertEqual(sut.getFibonacciIndex(afterValue: 0), 0)
        XCTAssertEqual(sut.getFibonacciIndex(afterValue: 1), 1)
        XCTAssertEqual(sut.getFibonacciIndex(afterValue: 2), 2)
        XCTAssertEqual(sut.getFibonacciIndex(afterValue: 3), 3)
        XCTAssertEqual(sut.getFibonacciIndex(afterValue: 4), 4)
        XCTAssertEqual(sut.getFibonacciIndex(afterValue: 5), 5)
        XCTAssertEqual(sut.getFibonacciIndex(afterValue: 8), 6)
    }
}
