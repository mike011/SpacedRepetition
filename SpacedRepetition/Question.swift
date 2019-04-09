//
//  Question.swift
//  SpacedRepetition
//
//  Created by Michael Charland on 2019-04-09.
//  Copyright © 2019 charland. All rights reserved.
//

import Foundation

/// Represent a question, so it holds the data about the question and handles updating the date on the question.
class Question: NSObject, NSCoding {

    /// How many days when answered correctly should it be to the next question.
    var incrementAmount: Int

    /// When was this question last answered correctly.
    var lastTimeAnswered: Date?

    /// When is the next time ask this question?
    var nextTimeToAsk: Date?

    /// What is the question?
    var question: String

    /// How many times has this question been asked?
    var timesAsked: Int

    /// How many times has this question been answered correctly?
    var timesCorrect: Int

    /// Handles getting the next time to ask a question.
    private var spacedRepetition: SpacedRepetition

    init(withTitle title: String) {
        incrementAmount = 0
        question = title
        timesAsked = 0
        timesCorrect = 0
        spacedRepetition = SpacedRepetition(currentIncrementAmount: incrementAmount)
    }

    required init(coder aDecoder: NSCoder) {
        incrementAmount = aDecoder.decodeObject(forKey: "incrementAmount") as? Int ?? 0
        lastTimeAnswered = aDecoder.decodeObject(forKey: "lastTimeAnswered") as? Date ?? nil
        nextTimeToAsk = aDecoder.decodeObject(forKey: "nextTimeToAsk") as? Date ?? nil
        question = aDecoder.decodeObject(forKey: "question") as? String ?? ""
        timesAsked = aDecoder.decodeObject(forKey: "timesAsked") as? Int ?? 0
        timesCorrect = aDecoder.decodeObject(forKey: "timesCorrect") as? Int ?? 0
        spacedRepetition = SpacedRepetition(currentIncrementAmount: incrementAmount)
    }

    func encode(with aCoder: NSCoder) {
        aCoder.encode(incrementAmount, forKey: "incrementAmount")
        aCoder.encode(lastTimeAnswered, forKey: "lastTimeAnswered")
        aCoder.encode(nextTimeToAsk, forKey: "nextTimeToAsk")
        aCoder.encode(question, forKey: "question")
        aCoder.encode(timesAsked, forKey: "timesAsked")
        aCoder.encode(timesCorrect, forKey: "timesCorrect")
    }

    func handleRightAnswer() {
        timesAsked += 1
        timesCorrect += 1
        lastTimeAnswered = Date()
        incrementAmount = spacedRepetition.handleRightAnswer()

        var dateComponent = DateComponents()
        dateComponent.day = incrementAmount

        if nextTimeToAsk == nil{
            nextTimeToAsk = Date()
        }
        nextTimeToAsk = Calendar.current.date(byAdding: dateComponent, to: nextTimeToAsk!)
    }

    func handleWrongAnswer() {
        timesAsked += 1
        lastTimeAnswered = Date()
        incrementAmount = spacedRepetition.handleWrongAnswer()
        nextTimeToAsk = Date()
    }
}
