//
//  Questions.swift
//  SpacedRepetition
//
//  Created by Michael Charland on 2019-04-06.
//  Copyright © 2019 charland. All rights reserved.
//

import Foundation

/*
 * Right now the framework is working on the idea that when the app starts all the questions are added.
 * Then through out that life cycle the questions are updated.
 *
 * This does not work when there is already a question management system in place.
 * Is there a way to create a lighter library that only deals with updating questions?
 */

/// Manages everything to do with questions.
public class Questions {

    public var questionData = [Question]()
    public var allQuestionData = [Question]()
    private var currentQuestionIndex = 0

    public init(forCategory category: String? = nil) {
        loadAllQuestions(forCategory: category)
    }

    init(questions: [Question]) {
        allQuestionData = questions
        loadQuestions()
    }

    /// Loads all the stored questions.
    private func loadAllQuestions(forCategory category: String?) {
        // Hardcoded to using user defaults.
        let defaults = UserDefaults.standard
        if let savedQuestions = defaults.object(forKey: "questions") as? Data {
            if var decodedQuestions = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(savedQuestions) as! [Question] {
                decodedQuestions.sort()
                allQuestionData = decodedQuestions.filter({
                    if category == nil {
                        return true
                    }
                    return $0.category == category
                })
            }
        }
        loadQuestions()
    }

    /// You can add a bunch of questions with this method. If the questions have already been added they will be ignored.
    public func add(questions titles: [String], category: String? = nil) {
        for title in titles {
            addQuestion(withTitle: title, andCategory: category)
        }
        loadQuestions()
    }

    /// You can add one question with this method. If the question have already been added it will be ignored.
    public func add(question title: String, category: String? = nil) {
        addQuestion(withTitle: title, andCategory: category)
        loadQuestions()
    }

    private func addQuestion(withTitle title: String, andCategory category: String?) {
        let question = Question(withTitle: title, andCategory: category)
        if !allQuestionData.contains(question) {
            allQuestionData.append(question)
        }
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
        questionData.sort(by: { (q1, q2) -> Bool in
            guard let q1Next = q1.nextTimeToAsk else {
                return true
            }
            guard let q2Next = q2.nextTimeToAsk else {
                return false
            }
            return q1Next.compare(q2Next) == ComparisonResult.orderedDescending
        })
    }

    public func getCurrentQuestion() -> Question? {
        return questionData[currentQuestionIndex]
    }

    public func correctAnswer() {
        guard questionData.count > 0 else {
            return
        }

        questionData[currentQuestionIndex].handleRightAnswer()

        questionData.remove(at: currentQuestionIndex)
        save()
    }

    public func wrongAnswer() {
        guard questionData.count > 0 else {
            return
        }

        questionData[currentQuestionIndex].handleWrongAnswer()
        save()
    }

    public func getNextQuestion() -> Question? {

        guard questionData.count > 0 else {
            return nil
        }

        var newIndex = 0
        if questionData.count > 1 {
            let nextTimeToAsk = questionData[0].nextTimeToAsk
            let possibleNextQuestions = questionData.filter { (q) -> Bool in
                return q.nextTimeToAsk == nextTimeToAsk
            }
            if possibleNextQuestions.count > 1 {
                newIndex = currentQuestionIndex
                while newIndex == currentQuestionIndex {
                    newIndex = Int.random(in: 0 ..< possibleNextQuestions.count)
                }
            }
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

    func getDataToPrint() -> String {
        var toPrint = ""
        for data in allQuestionData {
            toPrint += "\(data) \n"
        }
        return toPrint
    }

    /// Helpful for debugging will print a small description of every question
    func print() {
        Swift.print(getDataToPrint())
    }
}
