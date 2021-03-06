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
        let q = Question(withTitle: "title", andCategory: "c")
        XCTAssertEqual(q.incrementAmount, 0)
        XCTAssertEqual(q.title, "title")
        XCTAssertEqual(q.category, "c")
        XCTAssertEqual(q.timesAsked, 0)
        XCTAssertEqual(q.incrementAmount, 0)
        XCTAssertEqual(q.timesCorrect, 0)
    }

    // MARK: - sorting
    func testBothHaveNeverBeenAsked() {
        let q1 = Question(withTitle: "a")
        let q2 = Question(withTitle: "b")
        XCTAssertTrue(q1 < q2)
    }

    func testSortingSecondQuestionHasNeverBeenAsked() {
        let q1 = Question(withTitle: "title")
        q1.lastTimeAnswered = Date()
        let q2 = Question(withTitle: "title2")
        XCTAssertTrue(q2 > q1)
    }

    func testSortingFirstQuestionHasNeverBeenAsked() {
        let q1 = Question(withTitle: "title")
        let q2 = Question(withTitle: "title2")
        q2.lastTimeAnswered = Date()
        XCTAssertTrue(q2 < q1)
    }

    func testSortingBothHaveBeenAskedFirstHasFutureDate() {
        let q1 = Question(withTitle: "title")
        q1.lastTimeAnswered = Date(timeIntervalSinceNow: 10)
        let q2 = Question(withTitle: "title2")
        q2.lastTimeAnswered = Date()
        XCTAssertTrue(q2 < q1)
    }

    func testSortingBothHaveBeenAskedSecondHasFutureDate() {
        let q1 = Question(withTitle: "title")
        q1.lastTimeAnswered = Date()
        let q2 = Question(withTitle: "title2")
        q2.lastTimeAnswered = Date(timeIntervalSinceNow: 10)
        XCTAssertTrue(q2 > q1)
    }

    func testSortingBothHaveSameDate() {
        let q1 = Question(withTitle: "title")
        q1.lastTimeAnswered = Date()
        let q2 = Question(withTitle: "title2")
        q2.lastTimeAnswered = Date()
        XCTAssertTrue(q2 > q1)
    }

    // MARK: - coder
    class MyCoder: NSCoder {

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

        let coder = MyCoder()
        coder.encode("t", forKey: "title")
        coder.encode("cat", forKey: "category")

        let q = Question(coder: coder)
        XCTAssertEqual(q.incrementAmount, 0)
        XCTAssertEqual(q.title, "t")
        XCTAssertEqual(q.category, "cat")
        XCTAssertEqual(q.timesAsked, 0)
        XCTAssertEqual(q.incrementAmount, 0)
        XCTAssertEqual(q.timesCorrect, 0)
    }

    func testEncoder() {

        let coder = MyCoder()
        coder.encode("t", forKey: "title")
        coder.encode("cat", forKey: "category")

        let q = Question(coder: coder)

        let coder2 = MyCoder()
        q.encode(with: coder2)
        XCTAssertEqual("t", coder2.decodeObject(forKey: "title") as! String)
        XCTAssertEqual("cat", coder2.decodeObject(forKey: "category") as! String)
    }

    // MARK: - right answer
    func testHandleRightAnswer() {
        let q = Question(withTitle: "title")
        q.handleRightAnswer()
        XCTAssertEqual(q.timesAsked, 1)
        XCTAssertEqual(q.timesCorrect, 1)
        XCTAssertEqual(q.incrementAmount, 1)
        XCTAssertNotNil(q.lastTimeAnswered)
        XCTAssertNotNil(q.nextTimeToAsk)
    }

    // MARK: - wrong answer
    func testHandleWrongAnswer() {
        let q = Question(withTitle: "title")
        q.handleWrongAnswer()
        XCTAssertEqual(q.timesAsked, 1)
        XCTAssertEqual(q.timesCorrect, 0)
        XCTAssertEqual(q.incrementAmount, 0)
        XCTAssertNotNil(q.lastTimeAnswered)
        XCTAssertNotNil(q.nextTimeToAsk)
    }

    // MARK: - Equivalence
    func testEqualsNil() {
        let q = Question(withTitle: "title")
        XCTAssertNotEqual(q, nil)
    }

    func testEqualsSameObject() {
        let q = Question(withTitle: "title")
        XCTAssertEqual(q, q)
    }

    func testEqualsDifferentObject() {
        let q = Question(withTitle: "title")
        let q2 = Question(withTitle: "title")
        XCTAssertEqual(q, q2)
    }

    func testEqualsDifferentTitles() {
        let q = Question(withTitle: "title")
        let q2 = Question(withTitle: "title2")
        XCTAssertNotEqual(q, q2)
    }

    func testEqualsSameCategories() {
        let q = Question(withTitle: "title")
        q.category = "a"
        let q2 = Question(withTitle: "title")
        q2.category = "a"
        XCTAssertEqual(q, q2)
    }

    func testEqualsDifferentCategories() {
        let q = Question(withTitle: "title")
        q.category = "a"
        let q2 = Question(withTitle: "title")
        q2.category = "b"
        XCTAssertNotEqual(q, q2)
    }

    func testEqualsDifferentCategoriesAndDifferentTitles() {
        let q = Question(withTitle: "title2")
        q.category = "a"
        let q2 = Question(withTitle: "title")
        q2.category = "b"
        XCTAssertNotEqual(q, q2)
    }

    // MARK: - Printing
    func testPrintingAQuestionWithNoCategory() {
        let q = Question(withTitle: "tip")
        var description = "tip \n"
        description += "lastTimeAnswered=nil\t"
        description += "timesAsked=0\t"
        description += "timesCorrect=0\t"
        description += "incrementAmount=0\t"
        description += "nextTimeToAsk=nil"
        XCTAssertEqual(q.description, description)

    }
    func testPrintingAQuestion() {
        let q = Question(withTitle: "tip", andCategory: "cat")
        var description = "cat - tip \n"
        description += "lastTimeAnswered=nil\t"
        description += "timesAsked=0\t"
        description += "timesCorrect=0\t"
        description += "incrementAmount=0\t"
        description += "nextTimeToAsk=nil"
        XCTAssertEqual(q.description, description)
    }
}
