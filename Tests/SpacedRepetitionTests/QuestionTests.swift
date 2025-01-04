//
//  QuestionTests.swift
//  SpacedRepetitionTests
//
//  Created by Michael Charland on 2019-04-14.
//  Copyright © 2019 charland. All rights reserved.
//

import Foundation
import Testing
@testable import SpacedRepetition

@Suite  struct QuestionTests {

    // MARK: - init
    @Test func initValues() {
        let q = Question(title: "title",
                         answer: "42",
                         category: "c")
        #expect(q.incrementInSeconds == 0)
        #expect(q.title == "title")
        #expect(q.category == "c")
        #expect(q.answer == "42")
        #expect(q.timesAsked == 0)
        #expect(q.incrementInSeconds == 0)
        #expect(q.timesCorrect == 0)
    }

    // MARK: - sorting
    @Test func bothHaveNeverBeenAsked() {
        let q1 = Question(title: "a")
        let q2 = Question(title: "b")
        #expect(q1 < q2)
    }

    @Test func sortingSecondQuestionHasNeverBeenAsked() {
        let q1 = Question(title: "title")
        q1.lastTimeAnswered = Date()
        let q2 = Question(title: "title2")
        #expect(q2 > q1)
    }

    @Test func sortingFirstQuestionHasNeverBeenAsked() {
        let q1 = Question(title: "title")
        let q2 = Question(title: "title2")
        q2.lastTimeAnswered = Date()
        #expect(q2 < q1)
    }

    @Test func sortingBothHaveBeenAskedFirstHasFutureDate() {
        let q1 = Question(title: "title")
        q1.lastTimeAnswered = Date(timeIntervalSinceNow: 10)
        let q2 = Question(title: "title2")
        q2.lastTimeAnswered = Date()
        #expect(q2 < q1)
    }

    @Test func sortingBothHaveBeenAskedSecondHasFutureDate() {
        let q1 = Question(title: "title")
        q1.lastTimeAnswered = Date()
        let q2 = Question(title: "title2")
        q2.lastTimeAnswered = Date(timeIntervalSinceNow: 10)
        #expect(q2 > q1)
    }

    @Test func sortingBothHaveSameDate() {
        let q1 = Question(title: "title")
        q1.lastTimeAnswered = Date()
        let q2 = Question(title: "title2")
        q2.lastTimeAnswered = Date()
        #expect(q2 > q1)
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

    @Test func coderInitValues() {

        let coder = MockCoder()
        coder.encode("t", forKey: "title")
        coder.encode("cat", forKey: "category")
        coder.encode("42", forKey: "answer")

        let q = Question(coder: coder)
        #expect(q.incrementInSeconds == 0)
        #expect(q.title == "t")
        #expect(q.category == "cat")
        #expect(q.answer == "42")
        #expect(q.timesAsked == 0)
        #expect(q.incrementInSeconds == 0)
        #expect(q.timesCorrect == 0)
    }

    @Test func encoder() {

        let coder = MockCoder()
        coder.encode("t", forKey: "title")
        coder.encode("cat", forKey: "category")
        coder.encode("42", forKey: "answer")

        let q = Question(coder: coder)

        let coder2 = MockCoder()
        q.encode(with: coder2)
        #expect("t" == coder2.decodeObject(forKey: "title") as! String)
        #expect("cat" == coder2.decodeObject(forKey: "category") as! String)
        #expect("42" == coder2.decodeObject(forKey: "answer") as! String)
    }

    // MARK: - Is right answer?
    @Test func isAnswerCorrectNope() {
        let q = Question(title: "frank", answer: "42", category: nil)
        let result = q.isCorrect("21")
        #expect(!result)
    }

    @Test func isAnswerCorrect() {
        let q = Question(title: "frank", answer: "42", category: nil)
        let result = q.isCorrect("42")
        #expect(result)
    }

    // MARK: - right answer
    @Test func handleRightAnswer() {
        let q = Question(title: "title")
        let start = Date()
        q.nextTimeToAsk = start
        q.handleRightAnswer(confidence: .medium)
        #expect(q.timesAsked == 1)
        #expect(q.timesCorrect == 1)
        #expect(q.incrementInSeconds == 120.0)
        #expect(q.lastTimeAnswered != nil)
        #expect(q.nextTimeToAsk != nil)
        #expect(q.nextTimeToAsk?.timeIntervalSince(start) == 120.0)
    }

    // MARK: - wrong answer
    @Test func handleWrongAnswer() {
        let q = Question(title: "title")
        q.handleWrongAnswer()
        #expect(q.timesAsked == 1)
        #expect(q.timesCorrect == 0)
        #expect(q.incrementInSeconds == 0)
        #expect(q.lastTimeAnswered != nil)
        #expect(q.nextTimeToAsk != nil)
    }

    // MARK: - Equivalence
    @Test func equalsNil() {
        let q = Question(title: "title")
        #expect(q != nil)
    }

    @Test func equalsSameObject() {
        let q = Question(title: "title")
        #expect(q == q)
    }

    @Test func equalsDifferentObject() {
        let q = Question(title: "title")
        let q2 = Question(title: "title")
        #expect(q == q2)
    }

    @Test func equalsDifferentTitles() {
        let q = Question(title: "title")
        let q2 = Question(title: "title2")
        #expect(q != q2)
    }

    @Test func equalsSameCategories() {
        let q = Question(title: "title", category: "a")
        let q2 = Question(title: "title", category: "a")
        #expect(q == q2)
    }

    @Test func equalsDifferentCategories() {
        let q = Question(title: "title", category: "a")
        let q2 = Question(title: "title", category: "b")
        #expect(q != q2)
    }

    @Test func equalsDifferentCategoriesAndDifferentTitles() {
        let q = Question(title: "title2", category: "a")
        let q2 = Question(title: "title", category: "b")
        #expect(q != q2)
    }

    // MARK: - Printing
    @Test func printingAQuestionWithNoCategory() {
        let q = Question(title: "tip")
        var description = "tip \n"
        description += "lastTimeAnswered=nil\t"
        description += "timesAsked=0\t"
        description += "timesCorrect=0\t"
        description += "incrementAmount=0.0\t"
        description += "nextTimeToAsk=nil"
        #expect(q.description == description)

    }
    @Test func printingAQuestion() {
        let q = Question(title: "tip", category: "cat")
        var description = "cat - tip \n"
        description += "lastTimeAnswered=nil\t"
        description += "timesAsked=0\t"
        description += "timesCorrect=0\t"
        description += "incrementAmount=0.0\t"
        description += "nextTimeToAsk=nil"
        #expect(q.description == description)
    }
}
