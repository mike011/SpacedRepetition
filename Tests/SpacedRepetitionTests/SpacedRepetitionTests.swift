//
//  SpacedRepetitionTests.swift
//  SpacedRepetitionTests
//
//  Created by Michael Charland on 2019-03-14.
//  Copyright © 2019 charland. All rights reserved.
//

import Foundation
import Testing
@testable import SpacedRepetition

@Suite struct SpacedRepetitionTests {

    // MARK: - handleWrongAnswer
    @Test func wrongAnswer() {
        let sut = SpacedRepetition(currentValue: 5, newQuestion: true)
        let date = sut.handleWrongAnswer()
        #expect(date == 0)
    }

    // MARK: - handleRightAnswer
    @Test func rightAnswerNeverAnsweredQuestionBefore() {
        let sut = SpacedRepetition(currentValue: 0, newQuestion: true)
        let date = sut.handleRightAnswer()
        #expect(date == 120.0)
    }

    @Test func rightAnswerLowConfidence() {
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

    @Test func rightAnswerLowConfidenceNotANewQuestion() {
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
                                       units: Units) {
        let actualInSeconds = sut.handleRightAnswer(confidence: confidence)
        let actual = getActual(from: actualInSeconds, units: units)
        #expect(actual == expected)
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

    @Test func rightAnswerMediumConfidence() {
        let sut = SpacedRepetition(currentValue: 1, newQuestion: true)
        assertRightAnswer(sut: sut, confidence: .medium, expected: 3, units: .minutes)
        assertRightAnswer(sut: sut, confidence: .medium, expected: 5, units: .minutes)
        assertRightAnswer(sut: sut, confidence: .medium, expected: 1, units: .days)
        assertRightAnswer(sut: sut, confidence: .medium, expected: 3, units: .days)
        assertRightAnswer(sut: sut, confidence: .medium, expected: 5, units: .days)
        assertRightAnswer(sut: sut, confidence: .medium, expected: 8, units: .days)
    }

    // MARK: - getFibonacciValue
    @Test func getFibonacciValue() {
        let sut = SpacedRepetition(currentValue: 1, newQuestion: true)
        #expect(sut.getFibonacciValue(atIndex: 0) == 1)
        #expect(sut.getFibonacciValue(atIndex: 1) == 2)
        #expect(sut.getFibonacciValue(atIndex: 2) == 3)
        #expect(sut.getFibonacciValue(atIndex: 3) == 4)
        #expect(sut.getFibonacciValue(atIndex: 4) == 5)
        #expect(sut.getFibonacciValue(atIndex: 5) == 8)
        #expect(sut.getFibonacciValue(atIndex: 6) == 13)
        #expect(sut.getFibonacciValue(atIndex: 8) == 34)
        #expect(sut.getFibonacciValue(atIndex: 15) == 987)
        #expect(sut.getFibonacciValue(atIndex: 16) == 987) // max // max
    }

    @Test func getFibonacciIndex() {
        let sut = SpacedRepetition(currentValue: 0, newQuestion: true)
        #expect(sut.getFibonacciIndex(afterValue: 0) == 0)
        #expect(sut.getFibonacciIndex(afterValue: 1) == 1)
        #expect(sut.getFibonacciIndex(afterValue: 2) == 2)
        #expect(sut.getFibonacciIndex(afterValue: 3) == 3)
        #expect(sut.getFibonacciIndex(afterValue: 4) == 4)
        #expect(sut.getFibonacciIndex(afterValue: 5) == 5)
        #expect(sut.getFibonacciIndex(afterValue: 8) == 6)
    }
}
