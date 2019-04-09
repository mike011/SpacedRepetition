//
//  SpacedRepetition.swift
//  SpacedRepetition
//
//  Created by Michael Charland on 2019-03-14.
//  Copyright © 2019 charland. All rights reserved.
//

import UIKit

/// This class only handles calculating the next date as to when to ask a question
class SpacedRepetition {

    private var incrementAmount: Int

    init(currentIncrementAmount: Int) {
        self.incrementAmount = currentIncrementAmount
    }

    func handleRightAnswer() -> Int {
        incrementAmount = fibonacci(getFibonacciIndex(incrementAmount))
        return incrementAmount
    }

    func handleWrongAnswer() -> Int {
        incrementAmount = 0
        return incrementAmount
    }

    func fibonacci(_ n: Int) -> Int {
        if n < 5 {
            // for small numbers just make it one more day.
            return n + 1
        }
        if n > 15 {
            // hard coded at a max of roughly 2.7 years
            return 987
        }
        var fibs: [Int] = [1, 1]
        if n >= 2 {
            (2...n).forEach { i in
                fibs.append(fibs[i - 1] + fibs[i - 2])
            }
        }
        return fibs.last!
    }

    func getFibonacciIndex(_ amount: Int) -> Int {
        if amount < 5 {
            return amount
        }
        return Int((log(Double(amount) * sqrt(5) + 0.5) / log(1.61803398875)).rounded())
    }
}
