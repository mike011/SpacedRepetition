//
//  QuestionsTests.swift
//  SpacedRepetitionTests
//
//  Created by Michael Charland on 2019-04-17.
//  Copyright © 2019 charland. All rights reserved.
//

import Foundation
import Testing
@testable import SpacedRepetition

@Suite struct QuestionsTests {

    init() {
        Self.cleanup(forKey: "questions")
    }

    // MARK: - init
    @Test func initAllQuestions() {
        let keyName = "initAllQuestions"
        defer {
            Self.cleanup(forKey: keyName)
        }
        let qs = Questions(keyName: keyName)
        var array1 = [Question]()
        array1.append(Question(title: "one", answer: nil, category: "c"))

        var array2 = [Question]()
        array2.append(Question(title: "two", answer: nil, category: "d"))

        qs.add(questions: array1)
        qs.add(questions: array2)
        qs.save()

        let qs2 = Questions(keyName: keyName)
        #expect(qs2.questionData.count == 2)
    }

    @Test func initOnlySpecifiedCategory() {
        let keyName = "initAllQuestions"
        defer {
            Self.cleanup(forKey: keyName)
        }
        let qs = Questions(keyName: keyName)
        var array1 = [Question]()
        array1.append(Question(title: "one", answer: nil, category: "c"))

        var array2 = [Question]()
        array2.append(Question(title: "two", answer: nil, category: "d"))

        qs.add(questions: array1)
        qs.add(questions: array2)
        qs.save()

        let qs2 = Questions(forCategory: "c", keyName: keyName)
        #expect(qs2.questionData.count == 1)
    }

    // MARK: - Adding
    @Test func addSameQuestionTwiceShouldOnlyBeAddedOnce() {
        let qs = Questions()
        qs.add(question: Question(title: "one", answer: nil, category: "c"))
        qs.add(question: Question(title: "one", answer: nil, category: "c"))
        #expect(qs.questionData.count == 1)
    }

    @Test func addTwoQuestionsShouldBeTwoQuestions() {
        let qs = Questions()
        qs.add(question: Question(title: "one", answer: nil, category: "c"))
        qs.add(question: Question(title: "two", answer: nil, category: "c"))
        #expect(qs.questionData.count == 2)
    }

    @Test func addSameQuestionTwiceWithDifferentCategoryShouldBeTwoQuestions() {
        let qs = Questions()
        qs.add(question: Question(title: "one", answer: nil, category: "c"))
        qs.add(question: Question(title: "one", answer: nil, category: "d"))
        #expect(qs.questionData.count == 2)
    }

    // MARK: - sorting
    @Test func allQuestionsIsSorted() {
        let q1 = Question(title: "q1")
        let q2 = Question(title: "q2")

        var qs = [q2,q1]
        qs.sort()

        #expect(qs[0].title == "q1")
        #expect(qs[1].title == "q2")
    }

    // MARK: - getNextQuestion
    @Test func getNextQuestionNoQuestions() {
        let qs = Questions()
        #expect(qs.questionData.isEmpty)
        #expect(qs.getNextQuestion() == nil)
    }

    @Test func getNextQuestionOneQuestion() {
        let qs = Questions()
        qs.add(questions: [Question(title: "one")])

        let q = qs.getNextQuestion()
        #expect(q != nil)
        #expect(q == qs.getNextQuestion())
    }

    @Test func getNextQuestionTwoQuestions() {
        let qs = Questions()
        qs.add(questions: [Question(title: "one"), Question(title: "two")])

        let q = qs.getNextQuestion()
        #expect(q != nil)

        let q2 = qs.getNextQuestion()
        #expect(q != q2)
    }

    @Test func getCurrentQuestionFirstOneNeverAnswed() {
        let one = Question(title: "one")

        let two = Question(title: "two")
        two.nextTimeToAsk = Calendar.current.date(byAdding: .day, value: -1, to: Date())

        let qs = Questions(questions: [one,two])

        let q2 = qs.getCurrentQuestion()
        #expect(q2?.title == "one")
    }

    @Test func getCurrentQuestionBothNeverAnswed() {
        let one = Question(title: "one")
        let two = Question(title: "two")

        let qs = Questions(questions: [one,two])

        let q2 = qs.getCurrentQuestion()
        #expect(q2?.title == "two")
    }

    @Test func getCurrentQuestionFirstOneAnsweredAndDue() {
        let one = Question(title: "one")
        one.nextTimeToAsk = Calendar.current.date(byAdding: .day, value: -1, to: Date())

        let two = Question(title: "two")
        let qs = Questions(questions: [one,two])

        let q2 = qs.getCurrentQuestion()
        #expect(q2?.title == "two")
    }

    @Test func getCurrentQuestionTwoQuestionsFirstOneOlderShouldBeAskedFirst() {
        let one = Question(title: "one")
        one.nextTimeToAsk = Calendar.current.date(byAdding: .day, value: -2, to: Date())

        let two = Question(title: "two")
        two.nextTimeToAsk = Calendar.current.date(byAdding: .day, value: -1, to: Date())

        let qs = Questions(questions: [one,two])
        let q2 = qs.getCurrentQuestion()
        #expect(q2?.title == "one")
    }

    @Test func noQuestionsShouldBeShownIfAllQuestionsAreForFutureDates() {

        // By marking a question correct it's next date to show will be at a later date.
        // Only if the question has been answered correctly more then 5 times.
        let qs = Questions()
        qs.add(questions: [Question(title: "one")])
        for i in 0..<5 {
            qs.correctAnswer(confidence: .low)
            #expect(qs.getNextQuestion() != nil, "failed at \(i)")
        }

        let qs2 = Questions()
        let q = qs2.getNextQuestion()
        #expect(q == nil)
    }

    @Test func unansweredQuestionsShouldAlwaysBeShownFirst() {

        let one = Question(title: "one")
        one.nextTimeToAsk = Calendar.current.date(byAdding: .day, value: -1, to: Date())

        let two = Question(title: "two")

        let qs = Questions(questions: [one,two])
        qs.correctAnswer()
        let q = qs.getNextQuestion()

        #expect(q?.title == "two")
    }

    @Test func unansweredQuestionsShouldAlwaysBeShownFirst2() {

        let one = Question(title: "one")
        one.nextTimeToAsk = Calendar.current.date(byAdding: .day, value: -1, to: Date())

        let two = Question(title: "two")
        let three = Question(title: "three")
        three.nextTimeToAsk = Calendar.current.date(byAdding: .day, value: 1, to: Date())

        let qs = Questions(questions: [one,two,three])
        qs.correctAnswer()
        let q = qs.getNextQuestion()

        #expect(q?.title == "two")
    }

    // MARK: - saving questions
    @Test func savingQuestion() {
        let qs = Questions(keyName: "savingQuestion")
        qs.add(questions: [Question(title: "one")])
        qs.save()

        let qs2 = Questions(keyName: "savingQuestion")
        #expect(qs2.questionData.count == 1)
    }

    // MARK: - wrong answer
    @Test func wrongAnswer() {
        let qs = Questions()
        qs.add(questions: [Question(title: "one")])
        qs.wrongAnswer()

        let q = qs.getNextQuestion()
        #expect(q != nil)
        #expect(q?.timesCorrect == 0)

        let qs2 = Questions()
        #expect(qs2.questionData.count == 1)
    }

    @Test func noQuestionLoaded() {
        let qs = Questions()
        qs.wrongAnswer()
        qs.correctAnswer()
        _ = qs.getNextQuestion()
    }

    @Test func wrongAnswerWithNoMoreQuestionsAvailable() {
        let qs = Questions()
        qs.add(questions: [Question(title: "one")])
        qs.correctAnswer()

        // should not crash
        qs.wrongAnswer()
    }

    // MARK: - correct answer
    @Test func correctAnswerOnce() {
        let qs = Questions()
        qs.add(questions: [Question(title: "one")])
        qs.correctAnswer()

        let q = qs.getNextQuestion()
        #expect(q != nil)

    }

    func atestCorrectAnswerOverThresholdForDay() {
        let qs = Questions()
        qs.add(questions: [Question(title: "one")])
        for _ in 0..<3 {
            #expect(qs.getCurrentQuestion() != nil)
            qs.correctAnswer()
        }

        let q = qs.getNextQuestion()
        #expect(q == nil)
    }

    @Test func correctAnswerWithNoMoreQuestionsAvailable() {
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
        #expect(qs.getDataToPrint() == "")
    }

    // MARK: - GetCurrentQuestion
    @Test func getcurrentQuestionWithNoQuestions() {
        let qs = Questions()
        #expect(qs.getCurrentQuestion() == nil)
    }

    private static func cleanup(forKey keyName: String) {
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: keyName)
    }

}
