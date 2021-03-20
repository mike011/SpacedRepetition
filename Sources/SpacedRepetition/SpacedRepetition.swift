//
//  SpacedRepetition.swift
//  SpacedRepetition
//
//  Created by Michael Charland on 2019-03-14.
//  Copyright © 2019 charland. All rights reserved.
//

import Foundation

/// This class only handles calculating the next date as to when to ask a question.
class SpacedRepetition {

    private var currentValue: Int
    private var lessThenADay: Bool

    init(currentValue: Int, newQuestion: Bool) {
        self.currentValue = currentValue
        lessThenADay = newQuestion
    }

    func handleRightAnswer(confidence: Confidence = .medium) -> TimeInterval {
        if confidence == .medium {
            currentValue += 1
        }
        let index = getFibonacciIndex(afterValue: Int(currentValue))
        let nextIncrement = getFibonacciValue(atIndex: index)
        currentValue = nextIncrement

        if currentValue <= 5 && lessThenADay {
            return TimeInterval(currentValue * 60)
        } else {
            if lessThenADay {
                lessThenADay = false
                currentValue = 1
            }
            return TimeInterval(currentValue * 86400)
        }
    }

    func handleWrongAnswer() -> TimeInterval {
        currentValue = 0
        return TimeInterval(currentValue)
    }


    /// - Parameter amount: The Fibonacci value.
    /// - Returns: The index in the Fibonacci sequence that you want.
    func getFibonacciIndex(afterValue amount: Int) -> Int {
        if amount < 5 {
            return amount
        }
        return Int((log(Double(amount) * sqrt(5) + 0.5) / log(1.61803398875)).rounded())
    }

    /// - Returns: The Fibonacci value at the index specified.
    func getFibonacciValue(atIndex index: Int) -> Int {
        if index < 5 {
            // for small numbers just make it one more day.
            return index + 1
        }
        if index > 15 {
            // hard coded at a max of roughly 2.7 years
            return 987
        }
        var fibs: [Int] = [1, 1]
        if index >= 2 {
            (2...index).forEach { i in
                fibs.append(fibs[i - 1] + fibs[i - 2])
            }
        }
        return fibs.last!
    }
}
