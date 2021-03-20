//
//  QuestionTests.swift
//  SpacedRepetitionTests
//
//  Created by Michael Charland on 2019-04-14.
//  Copyright © 2019 charland. All rights reserved.
//

import XCTest
@testable import SpacedRepetition

class QuestionTests: XCTestCase {

    // MARK: - init
    func testInitValues() {
        let q = Question(title: "title",
                         answer: "42",
                         category: "c")
        XCTAssertEqual(q.incrementInSeconds, 0)
        XCTAssertEqual(q.title, "title")
        XCTAssertEqual(q.category, "c")
        XCTAssertEqual(q.answer, "42")
        XCTAssertEqual(q.timesAsked, 0)
        XCTAssertEqual(q.incrementInSeconds, 0)
        XCTAssertEqual(q.timesCorrect, 0)
    }

    // MARK: - sorting
    func testBothHaveNeverBeenAsked() {
        let q1 = Question(title: "a")
        let q2 = Question(title: "b")
        XCTAssertTrue(q1 < q2)
    }

    func testSortingSecondQuestionHasNeverBeenAsked() {
        let q1 = Question(title: "title")
        q1.lastTimeAnswered = Date()
        let q2 = Question(title: "title2")
        XCTAssertTrue(q2 > q1)
    }

    func testSortingFirstQuestionHasNeverBeenAsked() {
        let q1 = Question(title: "title")
        let q2 = Question(title: "title2")
        q2.lastTimeAnswered = Date()
        XCTAssertTrue(q2 < q1)
    }

    func testSortingBothHaveBeenAskedFirstHasFutureDate() {
        let q1 = Question(title: "title")
        q1.lastTimeAnswered = Date(timeIntervalSinceNow: 10)
        let q2 = Question(title: "title2")
        q2.lastTimeAnswered = Date()
        XCTAssertTrue(q2 < q1)
    }

    func testSortingBothHaveBeenAskedSecondHasFutureDate() {
        let q1 = Question(title: "title")
        q1.lastTimeAnswered = Date()
        let q2 = Question(title: "title2")
        q2.lastTimeAnswered = Date(timeIntervalSinceNow: 10)
        XCTAssertTrue(q2 > q1)
    }

    func testSortingBothHaveSameDate() {
        let q1 = Question(title: "title")
        q1.lastTimeAnswered = Date()
        let q2 = Question(title: "title2")
        q2.lastTimeAnswered = Date()
        XCTAssertTrue(q2 > q1)
    }

    // MARK: - coder
    class MockCoder: NSCoder {

        var vals = [String: Any?]()

        override open func encode(_ object: Any?, forKey key: String) {
            vals[key] = object

        }

        override open func encode(_ value: Int64, forKey key: String) {

        }

        override open func decodeObject(forKey key: String) -> Any? {
            return vals[key] ?? nil
        }
    }

    func testCoderInitValues() {

        let coder = MockCoder()
        coder.encode("t", forKey: "title")
        coder.encode("cat", forKey: "category")
        coder.encode("42", forKey: "answer")

        let q = Question(coder: coder)
        XCTAssertEqual(q.incrementInSeconds, 0)
        XCTAssertEqual(q.title, "t")
        XCTAssertEqual(q.category, "cat")
        XCTAssertEqual(q.answer, "42")
        XCTAssertEqual(q.timesAsked, 0)
        XCTAssertEqual(q.incrementInSeconds, 0)
        XCTAssertEqual(q.timesCorrect, 0)
    }

    func testEncoder() {

        let coder = MockCoder()
        coder.encode("t", forKey: "title")
        coder.encode("cat", forKey: "category")
        coder.encode("42", forKey: "answer")

        let q = Question(coder: coder)

        let coder2 = MockCoder()
        q.encode(with: coder2)
        XCTAssertEqual("t", coder2.decodeObject(forKey: "title") as! String)
        XCTAssertEqual("cat", coder2.decodeObject(forKey: "category") as! String)
        XCTAssertEqual("42", coder2.decodeObject(forKey: "answer") as! String)
    }

    // MARK: - Is right answer?
    func testIsAnswerCorrectNope() {
        let q = Question(title: "frank", answer: "42", category: nil)
        let result = q.isCorrect("21")
        XCTAssertFalse(result)
    }

    func testIsAnswerCorrect() {
        let q = Question(title: "frank", answer: "42", category: nil)
        let result = q.isCorrect("42")
        XCTAssertTrue(result)
    }

    // MARK: - right answer
    func testHandleRightAnswer() {
        let q = Question(title: "title")
        let start = Date()
        q.nextTimeToAsk = start
        q.handleRightAnswer(confidence: .medium)
        XCTAssertEqual(q.timesAsked, 1)
        XCTAssertEqual(q.timesCorrect, 1)
        XCTAssertEqual(q.incrementInSeconds, 120.0)
        XCTAssertNotNil(q.lastTimeAnswered)
        XCTAssertNotNil(q.nextTimeToAsk)
        XCTAssertEqual(q.nextTimeToAsk?.timeIntervalSince(start), 120.0)
    }

    // MARK: - wrong answer
    func testHandleWrongAnswer() {
        let q = Question(title: "title")
        q.handleWrongAnswer()
        XCTAssertEqual(q.timesAsked, 1)
        XCTAssertEqual(q.timesCorrect, 0)
        XCTAssertEqual(q.incrementInSeconds, 0)
        XCTAssertNotNil(q.lastTimeAnswered)
        XCTAssertNotNil(q.nextTimeToAsk)
    }

    // MARK: - Equivalence
    func testEqualsNil() {
        let q = Question(title: "title")
        XCTAssertNotEqual(q, nil)
    }

    func testEqualsSameObject() {
        let q = Question(title: "title")
        XCTAssertEqual(q, q)
    }

    func testEqualsDifferentObject() {
        let q = Question(title: "title")
        let q2 = Question(title: "title")
        XCTAssertEqual(q, q2)
    }

    func testEqualsDifferentTitles() {
        let q = Question(title: "title")
        let q2 = Question(title: "title2")
        XCTAssertNotEqual(q, q2)
    }

    func testEqualsSameCategories() {
        let q = Question(title: "title", category: "a")
        let q2 = Question(title: "title", category: "a")
        XCTAssertEqual(q, q2)
    }

    func testEqualsDifferentCategories() {
        let q = Question(title: "title", category: "a")
        let q2 = Question(title: "title", category: "b")
        XCTAssertNotEqual(q, q2)
    }

    func testEqualsDifferentCategoriesAndDifferentTitles() {
        let q = Question(title: "title2", category: "a")
        let q2 = Question(title: "title", category: "b")
        XCTAssertNotEqual(q, q2)
    }

    // MARK: - Printing
    func testPrintingAQuestionWithNoCategory() {
        let q = Question(title: "tip")
        var description = "tip \n"
        description += "lastTimeAnswered=nil\t"
        description += "timesAsked=0\t"
        description += "timesCorrect=0\t"
        description += "incrementAmount=0.0\t"
        description += "nextTimeToAsk=nil"
        XCTAssertEqual(q.description, description)

    }
    func testPrintingAQuestion() {
        let q = Question(title: "tip", category: "cat")
        var description = "cat - tip \n"
        description += "lastTimeAnswered=nil\t"
        description += "timesAsked=0\t"
        description += "timesCorrect=0\t"
        description += "incrementAmount=0.0\t"
        description += "nextTimeToAsk=nil"
        XCTAssertEqual(q.description, description)
    }
}
