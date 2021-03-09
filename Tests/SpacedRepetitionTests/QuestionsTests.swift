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
        var array1 = [Question]()
        array1.append(Question(title: "one", answer: nil, category: "c"))

        var array2 = [Question]()
        array2.append(Question(title: "two", answer: nil, category: "d"))

        qs.add(questions: array1)
        qs.add(questions: array2)
        qs.save()

        let qs2 = Questions()
        XCTAssertEqual(qs2.questionData.count, 2)
    }

    func testInitOnlySpecifiedCategory() {
        let qs = Questions()
        var array1 = [Question]()
        array1.append(Question(title: "one", answer: nil, category: "c"))

        var array2 = [Question]()
        array2.append(Question(title: "two", answer: nil, category: "d"))

        qs.add(questions: array1)
        qs.add(questions: array2)
        qs.save()

        let qs2 = Questions(forCategory: "c")
        XCTAssertEqual(qs2.questionData.count, 1)
    }

    // MARK: - Adding
    func testAddSameQuestionTwiceShouldOnlyBeAddedOnce() {
        let qs = Questions()
        qs.add(question: Question(title: "one", answer: nil, category: "c"))
        qs.add(question: Question(title: "one", answer: nil, category: "c"))
        XCTAssertEqual(qs.questionData.count, 1)
    }

    func testAddTwoQuestionsShouldBeTwoQuestions() {
        let qs = Questions()
        qs.add(question: Question(title: "one", answer: nil, category: "c"))
        qs.add(question: Question(title: "two", answer: nil, category: "c"))
        XCTAssertEqual(qs.questionData.count, 2)
    }

    func testAddSameQuestionTwiceWithDifferentCategoryShouldBeTwoQuestions() {
        let qs = Questions()
        qs.add(question: Question(title: "one", answer: nil, category: "c"))
        qs.add(question: Question(title: "one", answer: nil, category: "d"))
        XCTAssertEqual(qs.questionData.count, 2)
    }

    // MARK: - sorting
    func testAllQuestionsIsSorted() {
        let q1 = Question(title: "q1")
        let q2 = Question(title: "q2")

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
        qs.add(questions: [Question(title: "one")])

        let q = qs.getNextQuestion()
        XCTAssertNotNil(q)
        XCTAssertEqual(q, qs.getNextQuestion())
    }

    func testGetNextQuestionTwoQuestions() {
        let qs = Questions()
        qs.add(questions: [Question(title: "one"),Question(title: "two")])

        let q = qs.getNextQuestion()
        XCTAssertNotNil(q)

        let q2 = qs.getNextQuestion()
        XCTAssertNotEqual(q, q2)
    }

    func testGetCurrentQuestionFirstOneNeverAnswed() {
        let one = Question(title: "one")

        let two = Question(title: "two")
        two.nextTimeToAsk = Calendar.current.date(byAdding: .day, value: -1, to: Date())

        let qs = Questions(questions: [one,two])

        let q2 = qs.getCurrentQuestion()
        XCTAssertEqual(q2?.title, "one")
    }

    func testGetCurrentQuestionBothNeverAnswed() {
        let one = Question(title: "one")
        let two = Question(title: "two")

        let qs = Questions(questions: [one,two])

        let q2 = qs.getCurrentQuestion()
        XCTAssertEqual(q2?.title, "two")
    }

    func testGetCurrentQuestionFirstOneAnsweredAndDue() {
        let one = Question(title: "one")
        one.nextTimeToAsk = Calendar.current.date(byAdding: .day, value: -1, to: Date())

        let two = Question(title: "two")
        let qs = Questions(questions: [one,two])

        let q2 = qs.getCurrentQuestion()
        XCTAssertEqual(q2?.title, "two")
    }

    func testGetCurrentQuestionTwoQuestionsFirstOneOlderShouldBeAskedFirst() {
        let one = Question(title: "one")
        one.nextTimeToAsk = Calendar.current.date(byAdding: .day, value: -2, to: Date())

        let two = Question(title: "two")
        two.nextTimeToAsk = Calendar.current.date(byAdding: .day, value: -1, to: Date())

        let qs = Questions(questions: [one,two])
        let q2 = qs.getCurrentQuestion()
        XCTAssertEqual(q2?.title, "one")
    }

    func testNoQuestionsShouldBeShownIfAllQuestionsAreForFutureDates() {

        // By marking a question correct it's next date to show will be at a later date.
        let qs = Questions()
        qs.add(questions: [Question(title: "one")])
        qs.correctAnswer()

        let qs2 = Questions()
        let q = qs2.getNextQuestion()
        XCTAssertNil(q)
    }

    func testUnansweredQuestionsShouldAlwaysBeShownFirst() {

        let one = Question(title: "one")
        one.nextTimeToAsk = Calendar.current.date(byAdding: .day, value: -1, to: Date())

        let two = Question(title: "two")
        let three = Question(title: "three")

        let qs = Questions(questions: [one,two,three])
        qs.correctAnswer()
        let q = qs.getNextQuestion()

        XCTAssertEqual(q?.title, "two")
    }

    func testUnansweredQuestionsShouldAlwaysBeShownFirst2() {

        let one = Question(title: "one")
        one.nextTimeToAsk = Calendar.current.date(byAdding: .day, value: -1, to: Date())

        let two = Question(title: "two")
        let three = Question(title: "three")
        three.nextTimeToAsk = Calendar.current.date(byAdding: .day, value: 1, to: Date())

        let qs = Questions(questions: [one,two,three])
        qs.correctAnswer()
        let q = qs.getNextQuestion()

        XCTAssertEqual(q?.title, "one")
    }

    // MARK: - saving questions
    func testSavingQuestion() {
        let qs = Questions()
        qs.add(questions: [Question(title: "one")])
        qs.save()

        let qs2 = Questions()
        XCTAssertEqual(qs2.questionData.count, 1)
    }

    // MARK: - wrong answer
    func testWrongAnswer() {
        let qs = Questions()
        qs.add(questions: [Question(title: "one")])
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
        qs.add(questions: [Question(title: "one")])
        qs.correctAnswer()

        // should not crash
        qs.wrongAnswer()
    }

    // MARK: - correct answer
    func testCorrectAnswer() {
        let qs = Questions()
        qs.add(questions: [Question(title: "one")])
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
        qs.add(questions: [Question(title: "one")])
        qs.correctAnswer()

        // should not crash
        qs.correctAnswer()
    }

    // MARK: - Printing
    func skipNotReadytestPrintingOneQuestion() {
        let qs = Questions()
        qs.add(questions: [Question(title: "one")])
        XCTAssertEqual(qs.getDataToPrint(), "")
    }

}
