//
//  QuestionViewModel.swift
//  Example
//
//  Created by Michael Charland on 2025-01-04.
//

import Foundation
import SpacedRepetition

struct QuestionViewModel {

    private let questions: Questions
    private var currentQuestion: Question?

    init(questions: Questions) {
        self.questions = questions
        self.currentQuestion = questions.getNextQuestion()
    }

    var questionTitle: String {
        currentQuestion?.title ?? "not set"
    }

    var questionCount: String {
        "\(questions.questionData.count)"
    }

    var correctlyAnswered: String {
        "\(currentQuestion?.timesCorrect ?? 0)"
    }

    var lastTimeAsked: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd, yyyy"
        if let date = currentQuestion?.lastTimeAnswered {
            return formatter.string(from: date)
        }
        return "Never"
    }

    var nextTimeToAsk: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd, yyyy"
        if let date = currentQuestion?.nextTimeToAsk {
            return formatter.string(from: date)
        } else {
            return "Today"
        }
    }

    func correctAnswer() {
        questions.correctAnswer()
    }

    func incorrectAnswer() {
        questions.wrongAnswer()
    }

    mutating func nextQuestion() {
        currentQuestion = questions.getNextQuestion()
    }
}
