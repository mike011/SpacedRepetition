//
//  Questions.swift
//  SpacedRepetition
//
//  Created by Michael Charland on 2019-04-06.
//  Copyright © 2019 charland. All rights reserved.
//

import Foundation

/// Manages everything to do with questions
public class Questions {

    public var questionData = [Question]()
    private var currentQuestionIndex = 0

    public init() {
        loadQuestions()
    }

    func loadQuestions() {
        let defaults = UserDefaults.standard
        if let savedQuestions = defaults.object(forKey: "questions") as? Data {
            if let decodedQuestions = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(savedQuestions) as? [Question] {
                questionData = decodedQuestions
            }
        }
    }

    /// If you've never added questions, this is the function to call to add them.
    public func add(questions titles: [String]) {
        if questionData.isEmpty {
            for title in titles {
                questionData.append(Question(withTitle: title))
            }
        }
    }

    public func correctAnswer() {
        questionData[currentQuestionIndex].handleRightAnswer()
        save()

        // This is removing it from the user defaults!!!
        questionData.remove(at: currentQuestionIndex)
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
        if let savedData = try? NSKeyedArchiver.archivedData(withRootObject: questionData, requiringSecureCoding: false) {
            let defaults = UserDefaults.standard
            defaults.set(savedData, forKey: "questions")
        }
    }
}
