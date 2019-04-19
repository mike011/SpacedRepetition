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

    func testSavingQuestion() {
        let qs = Questions()
        qs.add(questions: ["one"])
        qs.save()

        let qs2 = Questions()
        XCTAssertEqual(qs2.questionData.count, 1)
    }

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

    func testNoQuestionsShouldBeShownIfAllQuestionsAreForFutureDates() {

        // By marking a question correct it's next date to show will be at a later date.
        let qs = Questions()
        qs.add(questions: ["one"])
        qs.correctAnswer()

        let qs2 = Questions()
        let q = qs2.getNextQuestion()
        XCTAssertNil(q)
    }
}
