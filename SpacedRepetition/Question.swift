//
//  Question.swift
//  SpacedRepetition
//
//  Created by Michael Charland on 2019-04-09.
//  Copyright © 2019 charland. All rights reserved.
//

import Foundation

/// Represent a question, so it holds the data about the question and handles updating the date on the question.
public class Question: NSObject, NSCoding, Comparable {

    /// What is the question?
    public var title: String

    /// What is the category the question exists in?
    public var category: String?

    /// When was this question last answered correctly?
    public var lastTimeAnswered: Date?

    /// How many times has this question been asked?
    public var timesAsked: Int

    /// How many times has this question been answered correctly?
    var timesCorrect: Int

    /// How many days when answered correctly should it be to the next question?
    var incrementAmount: Int

    /// When is the next time ask this question?
    var nextTimeToAsk: Date?

    /// Handles getting the next time to ask a question.
    private var spacedRepetition: SpacedRepetition

    enum Key: String {
        case title
        case category
        case lastTimeAnswered
        case timesAsked
        case timesCorrect
        case incrementAmount
        case nextTimeToAsk
    }

    init(withTitle: String, andCategory: String? = nil) {
        incrementAmount = 0
        title = withTitle
        category = andCategory
        timesAsked = 0
        timesCorrect = 0
        spacedRepetition = SpacedRepetition(currentIncrementAmount: incrementAmount)
    }

    public required init(coder aDecoder: NSCoder) {
        title = aDecoder.decodeObject(forKey: .title) as? String ?? ""
        category = aDecoder.decodeObject(forKey: .category) as? String ?? nil
        lastTimeAnswered = aDecoder.decodeObject(forKey: .lastTimeAnswered) as? Date ?? nil
        timesAsked = aDecoder.decodeObject(forKey: .timesAsked) as? Int ?? 0
        timesCorrect = aDecoder.decodeObject(forKey: .timesCorrect) as? Int ?? 0
        incrementAmount = aDecoder.decodeObject(forKey: .incrementAmount) as? Int ?? 0
        nextTimeToAsk = aDecoder.decodeObject(forKey: .nextTimeToAsk) as? Date ?? nil

        spacedRepetition = SpacedRepetition(currentIncrementAmount: incrementAmount)
    }

    public func encode(with aCoder: NSCoder) {
        aCoder.encode(title, forKey: .title)
        aCoder.encode(category, forKey: .category)
        aCoder.encode(lastTimeAnswered, forKey: .lastTimeAnswered)
        aCoder.encode(timesAsked, forKey: .timesAsked)
        aCoder.encode(timesCorrect, forKey: .timesCorrect)
        aCoder.encode(incrementAmount, forKey: .incrementAmount)
        aCoder.encode(nextTimeToAsk, forKey: .nextTimeToAsk)
    }

    func handleRightAnswer() {
        lastTimeAnswered = Date()
        timesAsked += 1
        timesCorrect += 1
        incrementAmount = spacedRepetition.handleRightAnswer()

        var dateComponent = DateComponents()
        dateComponent.day = incrementAmount

        if nextTimeToAsk == nil{
            nextTimeToAsk = Date()
        }
        nextTimeToAsk = Calendar.current.date(byAdding: dateComponent, to: nextTimeToAsk!)
    }

    func handleWrongAnswer() {
        lastTimeAnswered = Date()
        timesAsked += 1
        incrementAmount = spacedRepetition.handleWrongAnswer()
        nextTimeToAsk = Date()
    }

    override public func isEqual(_ object: Any?) -> Bool {
        guard let b = object as? Question else {
            return false
        }
        return category == b.category && title == b.title
    }
}

extension NSCoder {

    func encode(_ object: Any?, forKey key: Question.Key) {
        encode(object, forKey: key.rawValue)
    }

    func decodeObject(forKey key: Question.Key) -> Any? {
        return decodeObject(forKey: key.rawValue)
    }
}

public func < (left: Question, right: Question) -> Bool {

    let leftLastTimeAnswerd = left.lastTimeAnswered
    let rightLastTimeAnswerd = right.lastTimeAnswered
    if leftLastTimeAnswerd == nil && rightLastTimeAnswerd == nil {
        return left.title.compare(right.title) == .orderedAscending
    }
    if leftLastTimeAnswerd == nil { return false }
    if rightLastTimeAnswerd == nil { return true }

    return leftLastTimeAnswerd!.compare(rightLastTimeAnswerd!) == .orderedAscending
}

// MARK: - Debugging
extension Question {

    /// Handlings creating the string for debugging
    override public var description: String {
        var categoryDescription = ""
        if let category = category {
            categoryDescription = "\(category) - "
        }
        var result = "\(categoryDescription)\(title) \n"
        result += "lastTimeAnswered=\(String(describing: lastTimeAnswered))\t"
        result += "timesAsked=\(timesAsked)\t"
        result += "timesCorrect=\(timesCorrect)\t"
        result += "incrementAmount=\(incrementAmount)\t"
        result += "nextTimeToAsk=\(String(describing: nextTimeToAsk))"
        return result
    }
}
