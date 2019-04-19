//
//  Questions.swift
//  SpacedRepetition
//
//  Created by Michael Charland on 2019-04-06.
//  Copyright © 2019 charland. All rights reserved.
//

import Foundation

/// Manages everything to do with questions.
public class Questions {

    public var questionData = [Question]()
    internal var allQuestionData = [Question]()
    private var currentQuestionIndex = 0

    public init() {
        loadAllQuestions()
    }

    /// Loads all the stored questions.
    private func loadAllQuestions() {
        // Hardcoded to using user defaults.
        let defaults = UserDefaults.standard
        if let savedQuestions = defaults.object(forKey: "questions") as? Data {
            if let decodedQuestions = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(savedQuestions) as? [Question] {
                allQuestionData = decodedQuestions
            }
        }
        loadQuestions()
    }

    /// If you've never added questions, this is the function to call to add them.
    public func add(questions titles: [String]) {
        if allQuestionData.isEmpty {
            for title in titles {
                allQuestionData.append(Question(withTitle: title))
            }
        }
        loadQuestions()
    }

    /// Loads only the questions needed for the day.
    func loadQuestions() {
        questionData = allQuestionData.filter { (q) -> Bool in

            // You've never answered the question
            guard let next = q.nextTimeToAsk else {
                return true
            }

            // The question should be asked today
            return next.compare(Date()) == ComparisonResult.orderedAscending
        }
    }

    public func correctAnswer() {
        questionData[currentQuestionIndex].handleRightAnswer()

        questionData.remove(at: currentQuestionIndex)
        currentQuestionIndex = -1

        save()
    }

    public func wrongAnswer() {
        questionData[currentQuestionIndex].handleWrongAnswer()
        save()
    }

    public func getNextQuestion() -> Question? {

        guard questionData.count > 0 else {
            return nil
        }

        var newIndex = currentQuestionIndex
        while newIndex == currentQuestionIndex && questionData.count != 1 {
            newIndex = Int.random(in: 0 ..< questionData.count)
        }
        currentQuestionIndex = newIndex
        return questionData[currentQuestionIndex]
    }

    func save() {
        if let savedData = try? NSKeyedArchiver.archivedData(withRootObject: allQuestionData, requiringSecureCoding: false) {
            let defaults = UserDefaults.standard
            defaults.set(savedData, forKey: "questions")
        }
    }
}
