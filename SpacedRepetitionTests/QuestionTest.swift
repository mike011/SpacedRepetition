//
//  QuestionTest.swift
//  SpacedRepetitionTests
//
//  Created by Michael Charland on 2019-04-14.
//  Copyright © 2019 charland. All rights reserved.
//

import XCTest
@testable import SpacedRepetition

class QuestionTest: XCTestCase {

    func testInitValues() {
        let q = Question(withTitle: "title")
        XCTAssertEqual(q.incrementAmount, 0)
        XCTAssertEqual(q.title, "title")
        XCTAssertEqual(q.timesAsked, 0)
        XCTAssertEqual(q.incrementAmount, 0)
        XCTAssertEqual(q.timesCorrect, 0)
    }

    class MyCoder: NSCoder {

        var vals = [String: Any?]()

        override open func encode(_ object: Any?, forKey key: String) {
            vals[key] = object

        }

        override open func encode(_ value: Int64, forKey key: String) {

        }

        override open func decodeObject(forKey key: String) -> Any? {
            return vals[key]
        }
    }

    func testCoderInitValues() {

        let coder = MyCoder()
        coder.encode("title", forKey: "title")

        let q = Question(coder: coder)
        XCTAssertEqual(q.incrementAmount, 0)
        XCTAssertEqual(q.title, "title")
        XCTAssertEqual(q.timesAsked, 0)
        XCTAssertEqual(q.incrementAmount, 0)
        XCTAssertEqual(q.timesCorrect, 0)
    }

    func testEncoder() {

        let coder = MyCoder()
        coder.encode("title", forKey: "title")
        let q = Question(coder: coder)

        let coder2 = MyCoder()
        q.encode(with: coder2)
        XCTAssertEqual("title", coder2.decodeObject(forKey: "title") as! String)
    }

    func testHandleRightAnswer() {
        let q = Question(withTitle: "title")
        q.handleRightAnswer()
        XCTAssertEqual(q.timesAsked, 1)
        XCTAssertEqual(q.timesCorrect, 1)
        XCTAssertEqual(q.incrementAmount, 1)
        XCTAssertNotNil(q.lastTimeAnswered)
        XCTAssertNotNil(q.nextTimeToAsk)
    }

    func testHandleWrongAnswer() {
        let q = Question(withTitle: "title")
        q.handleWrongAnswer()
        XCTAssertEqual(q.timesAsked, 1)
        XCTAssertEqual(q.timesCorrect, 0)
        XCTAssertEqual(q.incrementAmount, 0)
        XCTAssertNotNil(q.lastTimeAnswered)
        XCTAssertNotNil(q.nextTimeToAsk)
    }
}
