//
//  QuestionsTests.swift
//  SpacedRepetitionTests
//
//  Created by Michael Charland on 2019-04-17.
//  Copyright © 2019 charland. All rights reserved.
//

import XCTest
@testable import SpacedRepetition

class QuestionsTests: XCTestCase {

    override func setUp() {
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: "questions")
    }

    // MARK: - init
    func testInitAllQuestions() {
        let qs = Questions()
        qs.add(questions: ["one"], category: "c")
        qs.add(questions: ["two"], category: "d")
        qs.save()

        let qs2 = Questions()
        XCTAssertEqual(qs2.questionData.count, 2)
    }

    func testInitOnlySpecifiedCategory() {
        let qs = Questions()
        qs.add(questions: ["one"], category: "c")
        qs.add(questions: ["two"], category: "d")
        qs.save()

        let qs2 = Questions(forCategory: "c")
        XCTAssertEqual(qs2.questionData.count, 1)
    }

    // MARK: - Adding
    func testAddSameQuestionTwiceShouldOnlyBeAddedOnce() {
        let qs = Questions()
        qs.add(question: "one", category: "c")
        qs.add(question: "one", category: "c")
        XCTAssertEqual(qs.questionData.count, 1)
    }

    func testAddTwoQuestionsShouldBeTwoQuestions() {
        let qs = Questions()
        qs.add(question: "one", category: "c")
        qs.add(question: "two", category: "c")
        XCTAssertEqual(qs.questionData.count, 2)
    }

    func testAddSameQuestionTwiceWithDifferentCategoryShouldBeTwoQuestions() {
        let qs = Questions()
        qs.add(question: "one", category: "c")
        qs.add(question: "one", category: "d")
        XCTAssertEqual(qs.questionData.count, 2)
    }

    // MARK: - sorting
    func testAllQuestionsIsSorted() {
        let q1 = Question(withTitle: "q1")
        let q2 = Question(withTitle: "q2")

        var qs = [q2,q1]
        qs.sort()

        XCTAssertEqual(qs[0].title, "q1")
        XCTAssertEqual(qs[1].title, "q2")
    }

    // MARK: - getNextQuestion
    func testGetNextQuestionNoQuestions() {
        let qs = Questions()
        XCTAssertTrue(qs.questionData.isEmpty)
        XCTAssertNil(qs.getNextQuestion())
    }

    func testGetNextQuestionOneQuestion() {
        let qs = Questions()
        qs.add(questions: ["one"])

        let q = qs.getNextQuestion()
        XCTAssertNotNil(q)
        XCTAssertEqual(q, qs.getNextQuestion())
    }

    func testGetNextQuestionTwoQuestions() {
        let qs = Questions()
        qs.add(questions: ["one","two"])

        let q = qs.getNextQuestion()
        XCTAssertNotNil(q)

        let q2 = qs.getNextQuestion()
        XCTAssertNotEqual(q, q2)
    }

    func testNoQuestionsShouldBeShownIfAllQuestionsAreForFutureDates() {

        // By marking a question correct it's next date to show will be at a later date.
        let qs = Questions()
        qs.add(questions: ["one"])
        qs.correctAnswer()

        let qs2 = Questions()
        let q = qs2.getNextQuestion()
        XCTAssertNil(q)
    }

    // MARK: - saving questions
    func testSavingQuestion() {
        let qs = Questions()
        qs.add(questions: ["one"])
        qs.save()

        let qs2 = Questions()
        XCTAssertEqual(qs2.questionData.count, 1)
    }

    // MARK: - wrong answer
    func testWrongAnswer() {
        let qs = Questions()
        qs.add(questions: ["one"])
        qs.wrongAnswer()

        let q = qs.getNextQuestion()
        XCTAssertNotNil(q)
        XCTAssertEqual(q?.timesCorrect, 0)

        let qs2 = Questions()
        XCTAssertEqual(qs2.questionData.count, 1)
    }

    func testNoQuestionLoaded() {
        let qs = Questions()
        qs.wrongAnswer()
        qs.correctAnswer()
        _ = qs.getNextQuestion()
    }

    func testWrongAnswerWithNoMoreQuestionsAvailable() {
        let qs = Questions()
        qs.add(questions: ["one"])
        qs.correctAnswer()

        // should not crash
        qs.wrongAnswer()
    }

    // MARK: - correct answer
    func testCorrectAnswer() {
        let qs = Questions()
        qs.add(questions: ["one"])
        qs.correctAnswer()

        let q = qs.getNextQuestion()
        XCTAssertNil(q)

        let qs2 = Questions()
        XCTAssertFalse(qs2.allQuestionData.isEmpty)
        let q2 = qs2.allQuestionData[0]
        XCTAssertEqual(q2.timesCorrect, 1)
        XCTAssertNotNil(q2)
    }

    func testCorrectAnswerWithNoMoreQuestionsAvailable() {
        let qs = Questions()
        qs.add(questions: ["one"])
        qs.correctAnswer()

        // should not crash
        qs.correctAnswer()
    }

    // MARK: - Printing
    func skipNotReadytestPrintingOneQuestion() {
        let qs = Questions()
        qs.add(questions: ["one"])
        XCTAssertEqual(qs.getDataToPrint(), "")
    }

}
