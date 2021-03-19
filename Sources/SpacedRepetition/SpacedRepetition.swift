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

    private var incrementAmountInSeconds: TimeInterval

    init(currentIncrementAmount: TimeInterval) {
        self.incrementAmountInSeconds = currentIncrementAmount
    }

    func handleRightAnswer(confidence: Confidence = .medium) -> TimeInterval {
        switch confidence {
        case .extremlyLow:
            return incrementAmountInSeconds
        case .low:
            incrementAmountInSeconds += 1 /// Only adding one seconds!!!!!
        case .medium:
            let intValue = Int(incrementAmountInSeconds)
            let index = getFibonacciIndex(afterValue: intValue)
            let nextAmount = getFibonacciValue(atIndex: index)
            incrementAmountInSeconds = TimeInterval(nextAmount)
        }
        return incrementAmountInSeconds
    }

    func handleWrongAnswer() -> TimeInterval {
        incrementAmountInSeconds = 0
        return incrementAmountInSeconds
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
