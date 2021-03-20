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
        let sut = SpacedRepetition(currentValue: 5, newQuestion: true)
        let date = sut.handleWrongAnswer()
        XCTAssertEqual(date, 0)
    }

    // MARK: - handleRightAnswer
    func testRightAnswerNeverAnsweredQuestionBefore() {
        let sut = SpacedRepetition(currentValue: 0, newQuestion: true)
        let date = sut.handleRightAnswer()
        XCTAssertEqual(date, 120.0)
    }

    func testRightAnswerLowConfidence() {
        let sut = SpacedRepetition(currentValue: 1, newQuestion: true)
        assertRightAnswer(sut: sut, confidence: .low, expected: 2, units: .minutes)
        assertRightAnswer(sut: sut, confidence: .low, expected: 3, units: .minutes)
        assertRightAnswer(sut: sut, confidence: .low, expected: 4, units: .minutes)
        assertRightAnswer(sut: sut, confidence: .low, expected: 5, units: .minutes)
        assertRightAnswer(sut: sut, confidence: .low, expected: 1, units: .days)
        assertRightAnswer(sut: sut, confidence: .low, expected: 2, units: .days)
        assertRightAnswer(sut: sut, confidence: .low, expected: 3, units: .days)
        assertRightAnswer(sut: sut, confidence: .low, expected: 4, units: .days)
        assertRightAnswer(sut: sut, confidence: .low, expected: 5, units: .days)
        assertRightAnswer(sut: sut, confidence: .low, expected: 8, units: .days)
        assertRightAnswer(sut: sut, confidence: .low, expected: 13, units: .days)
        assertRightAnswer(sut: sut, confidence: .low, expected: 21, units: .days)
    }

    func testRightAnswerLowConfidenceNotANewQuestion() {
        let sut = SpacedRepetition(currentValue: 8, newQuestion: false)
        assertRightAnswer(sut: sut, confidence: .low, expected: 13, units: .days)
    }

    enum Units {
        case minutes
        case days
    }

    fileprivate func assertRightAnswer(sut: SpacedRepetition,
                                       confidence: Confidence,
                                       expected: TimeInterval,
                                       units: Units,
                                       file: StaticString = #file,
                                       line: UInt = #line) {
        let actualInSeconds = sut.handleRightAnswer(confidence: confidence)
        let actual = getActual(from: actualInSeconds, units: units)
        XCTAssertEqual(actual, expected, file: file, line: line)
    }

    fileprivate func getActual(from actualInSeconds: TimeInterval, units: Units) -> TimeInterval {
        var actual = 0.0
        switch units {
        case .minutes:
            actual = actualInSeconds / 60
        case .days:
            actual = actualInSeconds / 86400
        }
        return actual
    }

    func testRightAnswerMediumConfidence() {
        let sut = SpacedRepetition(currentValue: 1, newQuestion: true)
        assertRightAnswer(sut: sut, confidence: .medium, expected: 3, units: .minutes)
        assertRightAnswer(sut: sut, confidence: .medium, expected: 5, units: .minutes)
        assertRightAnswer(sut: sut, confidence: .medium, expected: 1, units: .days)
        assertRightAnswer(sut: sut, confidence: .medium, expected: 3, units: .days)
        assertRightAnswer(sut: sut, confidence: .medium, expected: 5, units: .days)
        assertRightAnswer(sut: sut, confidence: .medium, expected: 8, units: .days)
    }

    // MARK: - getFibonacciValue
    func testGetFibonacciValue() {
        let sut = SpacedRepetition(currentValue: 1, newQuestion: true)
        XCTAssertEqual(sut.getFibonacciValue(atIndex: 0), 1)
        XCTAssertEqual(sut.getFibonacciValue(atIndex: 1), 2)
        XCTAssertEqual(sut.getFibonacciValue(atIndex: 2), 3)
        XCTAssertEqual(sut.getFibonacciValue(atIndex: 3), 4)
        XCTAssertEqual(sut.getFibonacciValue(atIndex: 4), 5)
        XCTAssertEqual(sut.getFibonacciValue(atIndex: 5), 8)
        XCTAssertEqual(sut.getFibonacciValue(atIndex: 6), 13)
        XCTAssertEqual(sut.getFibonacciValue(atIndex: 8), 34)
        XCTAssertEqual(sut.getFibonacciValue(atIndex: 15), 987)
        XCTAssertEqual(sut.getFibonacciValue(atIndex: 16), 987) // max
    }

    func testGetFibonacciIndex() {
        let sut = SpacedRepetition(currentValue: 0, newQuestion: true)
        XCTAssertEqual(sut.getFibonacciIndex(afterValue: 0), 0)
        XCTAssertEqual(sut.getFibonacciIndex(afterValue: 1), 1)
        XCTAssertEqual(sut.getFibonacciIndex(afterValue: 2), 2)
        XCTAssertEqual(sut.getFibonacciIndex(afterValue: 3), 3)
        XCTAssertEqual(sut.getFibonacciIndex(afterValue: 4), 4)
        XCTAssertEqual(sut.getFibonacciIndex(afterValue: 5), 5)
        XCTAssertEqual(sut.getFibonacciIndex(afterValue: 8), 6)
    }
}
